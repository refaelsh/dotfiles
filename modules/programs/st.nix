{ inputs, ... }:
{
  # Vanilla nixpkgs st plus official suckless.org diffs. Not st-flexipatch
  # (a fork that ifdefs every patch): we take this flake's st and apply
  # each .diff ourselves so the binary is stock st plus only what is listed.
  #
  # Appearance lives in postPatch below, not a sidecar config.def.h. A
  # sidecar would have to copy every symbol the diffs add (clippaste,
  # font2, HISTSIZE, …) and would drift every time a patch or nixpkgs st
  # changes. substituteInPlace only rewrites the strings we care about.
  #
  # Combined ligatures+scrollback-ringbuffer is required: the standalone
  # ligatures diff does not apply on top of scrollback. Official diffs
  # that rejected against this 0.9.3 stack (boxdraw, selectioncolors) were
  # dropped, not hand-ported.
  #
  # import-tree turns this file into flake.nixosModules.st. The host
  # imports every nixosModules.* except "nixos" itself, so listing
  # st-patched in environment.systemPackages is enough to put `st` on PATH.
  flake.nixosModules.st =
    { pkgs, ... }:
    let
      # Official diffs are raw unified patches, not git-am mailboxes.
      # fetchurl keeps the file bytes as published. fetchpatch can rewrite
      # headers and would change the hash / fail to apply.
      official =
        url: sha256:
        pkgs.fetchurl {
          inherit url sha256;
        };

      st-patched =
        (pkgs.st.override {
          # Ligatures go through HarfBuzz (hb.c from that patch). Without
          # this, the extra .c file fails to link. extraLibs is the nixpkgs
          # st override for "add a library the diffs need".
          extraLibs = [ pkgs.harfbuzz ];
          patches = [
            # Shift+PageUp / PageDown scroll through history. Ringbuffer
            # (not the older linear scrollback) is the variant ligatures
            # publishes a combined diff for, and it is cheaper on long
            # history: old lines are overwritten in a fixed-size circle
            # instead of shifting a growing array.
            (official "https://st.suckless.org/patches/scrollback/st-scrollback-ringbuffer-0.9.2.diff" "1r23q4mi5bkam49ld5c3ccwaa1li7bbjx0ndjgm207p02az9h4cn")
            # Draws ligatures (fi, !=, =>, …) via HarfBuzz. Must be the
            # *-scrollback-ringbuffer combined file: vanilla ligatures
            # edits the same drawing path scrollback already changed.
            (official "https://st.suckless.org/patches/ligatures/0.9.3/st-ligatures-scrollback-ringbuffer-20251007-0.9.3.diff" "0c2w1p0siafiyarfx6skdighwzw29d1mydpjfrwgrvdsywwyq2di")
            # Shift+mouse-wheel scrolls the same history as PageUp/Down.
            # Official order: this on top of scrollback, then altscreen.
            (official "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-0.9.2.diff" "068s5rjvvw2174y34i5xxvpw4jvjy58akd1kgf025h1153hmf7jy")
            # Wheel without Shift: if the app is on the alternate screen
            # (less, vim, htop) the app gets the wheel; otherwise the
            # wheel scrolls st's history. Matches Ghostty / modern xterm.
            (official "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-altscreen-20220127-2c5edf2.diff" "078hk7k5i0vc2x4dyb65dxd5ykr32pz4f4j6h0f7pm8j7xl1fbwg")
            # Selecting text writes CLIPBOARD (Ctrl+C / browser paste),
            # not only PRIMARY (middle-click). Paste bindings still read
            # PRIMARY until postPatch switches them to clippaste.
            (official "https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff" "1h1nwilwws02h2lnxzmrzr69lyh6pwsym21hvalp9kmbacwy6p0g")
            # Vanilla st paints bold as the *bright* colour of that slot
            # (red3 becomes red). Themes then cannot use bright colours
            # independently of bold. After this, bold is only a weight.
            (official "https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff" "1cpap2jz80n90izhq5fdv2cvg29hj6bhhvjxk40zkskwmjn6k49j")
            # Fallback font list (`font2[]`). Fira Code has no emoji and
            # few icons; without this, those glyphs are empty boxes.
            # postPatch uncomment / fills the two example slots.
            (official "https://st.suckless.org/patches/font2/st-font2-0.8.5.diff" "1wd4lxl0fmv78ibnf4yksribxhg3jzpqnjxhp0jyjbkz7a48m89f")
            # Vanilla st snaps the window to a multiple of the cell size,
            # which leaves gaps under a tiling WM. expected-anysize fills
            # the allocated pixels and puts leftover padding on the
            # bottom/right (left-to-right, top-down). The other anysize
            # variant centers the grid and makes the text "swim" while
            # resizing.
            (official "https://st.suckless.org/patches/anysize/st-expected-anysize-0.9.diff" "04gvkf80lhaiwyv3m7fdkf81msf8al1kfb7inx1bf02ygx9152v2")
            # Installs st.desktop so launchers and the session can find
            # st by name / icon. Does not change the terminal itself.
            (official "https://st.suckless.org/patches/desktopentry/st-desktopentry-0.8.5.diff" "1nhr56j2jw7llpiig8j65iwsjxkl2h96rar4nlnwrqv4mgmgsncw")
            # CSI 22 / 23 save and restore the window title. nvim (and
            # similar) set a title on enter and expect the previous one
            # back on exit; without this, the title sticks.
            (official "https://st.suckless.org/patches/csi_22_23/st-csi_22_23-0.8.5.diff" "0w0zfymq5xy0b6cb8dnqvlzfax43l5dfdy806v40ganwfxwbxh09")
            # Application-synchronized updates (iTerm2 / tmux protocol):
            # the app tells st when a draw batch is finished so st does
            # not paint a half-frame. Auto-sync is already upstream;
            # this is only the application-sync half. tmux enables it
            # from terminfo when it is present.
            (official "https://st.suckless.org/patches/sync/st-appsync-20200618-b27a383.diff" "1x2qb65p0jj6f5gb49xildry0aqkls4ayazyr99z7824bvkivz94")
            # Cursor cell is drawn with fg/bg swapped, like Alacritty,
            # so the glyph under the cursor stays readable on any colour.
            (official "https://st.suckless.org/patches/dynamic-cursor-color/st-dynamic-cursor-color-0.9.diff" "1hpyk30a5mkj3lplmxhp8j61y3yxmsg8sx5wjfbvcriv43fcdb5a")
            # `st -d DIR` chdir's before spawning the shell. The official
            # diff calls chdir(opt_dir) even when -d was not given
            # (opt_dir is then NULL). postPatch guards that call.
            (official "https://st.suckless.org/patches/workingdir/st-workingdir-20200317-51e19ea.diff" "1pwx6gppqbx0gkyw62i1qwpigr9nw0chnzr0f3jylv9gzxyvxfhy")
          ];
        }).overrideAttrs
          (old: {
            # The official diffs already ran. This is not more patches: it is
            # search-and-replace on the resulting C sources so st matches the
            # rest of the desktop (font, Dracula, Ghostty-like chrome/paste).
            #
            # overrideAttrs keeps the package from st.override above and only
            # changes the build. postPatch is a shell snippet Nix runs after
            # applying the .diff files and before make. config.def.h is st's
            # config; the Makefile copies it to config.h and compiles that.
            #
            # (old.postPatch or "") keeps nixpkgs' own postPatch (usually
            # empty on Linux) and appends ours. The '' … '' is that script.
            #
            # substituteInPlace FILE --replace-fail OLD NEW rewrites every
            # OLD to NEW. --replace-fail dies if OLD is missing, so a future
            # st/nixpkgs change that moves these strings fails the rebuild
            # instead of shipping an unthemed terminal. A trailing \ continues
            # the same substituteInPlace; each --replace-fail is another pair.
            postPatch = (old.postPatch or "") + ''
              # Same family/size as Ghostty. font2 ships commented out;
              # uncomment so glyphs missing from Fira Code (emoji, some
              # icons) come from fonts already in fonts.nix.
              substituteInPlace config.def.h \
                --replace-fail 'static char *font = "Liberation Mono:pixelsize=12:antialias=true:autohint=true";' \
                               'static char *font = "FiraCode Nerd Font:size=12:antialias=true:autohint=true";' \
                --replace-fail '/*	"Inconsolata for Powerline:pixelsize=12:antialias=true:autohint=true", */' \
                               '	"Noto Color Emoji:size=12:antialias=true:autohint=true",' \
                --replace-fail '/*	"Hack Nerd Font Mono:pixelsize=11:antialias=true:autohint=true", */' \
                               '	"Font Awesome 6 Free:size=12:antialias=true:autohint=true",'

              # borderpx 0: no inner padding. cursorshape 6: bar cursor ("|").
              # allowwindowops 1: OSC 52 so nvim/remote can set the clipboard;
              # a hostile host can then also set the clipboard.
              substituteInPlace config.def.h \
                --replace-fail 'static int borderpx = 2;' \
                               'static int borderpx = 0;' \
                --replace-fail 'int allowwindowops = 0;' \
                               'int allowwindowops = 1;' \
                --replace-fail 'static unsigned int cursorshape = 2;' \
                               'static unsigned int cursorshape = 6;'

              # Clipboard patch already *copies* the selection to CLIPBOARD.
              # Vanilla paste still reads PRIMARY (selpaste). Switch paste to
              # CLIPBOARD so select-then-middle-click / Ctrl+Shift+Y /
              # Shift+Insert matches select-then-paste in a browser.
              substituteInPlace config.def.h \
                --replace-fail '{ XK_ANY_MOD,           Button2, selpaste,       {.i = 0},      1 },' \
                               '{ XK_ANY_MOD,           Button2, clippaste,      {.i = 0},      1 },' \
                --replace-fail '{ TERMMOD,              XK_Y,           selpaste,       {.i =  0} },' \
                               '{ TERMMOD,              XK_Y,           clippaste,      {.i =  0} },' \
                --replace-fail '{ ShiftMask,            XK_Insert,      selpaste,       {.i =  0} },' \
                               '{ ShiftMask,            XK_Insert,      clippaste,      {.i =  0} },'

              # Dracula palette. Order matters: the dedicated default fg/bg
              # entries ("gray90"/"black" plus their comments) must be replaced
              # before the bare "gray90"/"black" ANSI slots, or those dedicated
              # lines would become the ANSI hex too. After that: 16 ANSI colors,
              # then the extra slots after 255 (cursor, reverse-cursor).
              substituteInPlace config.def.h \
                --replace-fail '"black", /* default background colour */' '"#282a36", /* default background colour */' \
                --replace-fail '"gray90", /* default foreground colour */' '"#f8f8f2", /* default foreground colour */' \
                --replace-fail '"black",' '"#21222c",' \
                --replace-fail '"red3",' '"#ff5555",' \
                --replace-fail '"green3",' '"#50fa7b",' \
                --replace-fail '"yellow3",' '"#f1fa8c",' \
                --replace-fail '"blue2",' '"#bd93f9",' \
                --replace-fail '"magenta3",' '"#ff79c6",' \
                --replace-fail '"cyan3",' '"#8be9fd",' \
                --replace-fail '"gray90",' '"#f8f8f2",' \
                --replace-fail '"gray50",' '"#6272a4",' \
                --replace-fail '"red",' '"#ff6e6e",' \
                --replace-fail '"green",' '"#69ff94",' \
                --replace-fail '"yellow",' '"#ffffa5",' \
                --replace-fail '"#5c5cff",' '"#d6acff",' \
                --replace-fail '"magenta",' '"#ff92df",' \
                --replace-fail '"cyan",' '"#a4ffff",' \
                --replace-fail '"white",' '"#ffffff",' \
                --replace-fail '"#cccccc",' '"#f8f8f2",' \
                --replace-fail '"#555555",' '"#282a36",'

              # Ringbuffer history size lives in st.h, not config.def.h.
              # 2000 lines is short for a compiler / test run; 20000 is
              # still a fixed ring (memory stays bounded).
              substituteInPlace st.h \
                --replace-fail '#define HISTSIZE            2000' \
                               '#define HISTSIZE            20000'

              # workingdir always calls chdir(opt_dir). Without -d, opt_dir is
              # NULL and chdir(NULL) is undefined. Only chdir when -d was given.
              substituteInPlace x.c \
                --replace-fail 'chdir(opt_dir);' \
                               'if (opt_dir) chdir(opt_dir);'
            '';
          });
    in
    {
      # Only this derivation: nixpkgs' unpatched st is not also on PATH.
      environment.systemPackages = [ st-patched ];
    };
}

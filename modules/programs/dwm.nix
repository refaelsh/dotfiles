{ inputs, ... }:
{
  # Vanilla nixpkgs dwm plus official suckless.org diffs. Same idea as
  # st.nix: not dwm-flexipatch, no sidecar config.h. The diffs own
  # config.def.h; postPatch only rewrites appearance and keys.
  #
  # xmonad stays the LightDM default (services.nix
  # defaultSession = "none+xmonad"). Enabling this module only adds a
  # second session named "dwm". Auto-login still starts xmonad; pick
  # dwm at the greeter (or disable auto-login once) to try it.
  #
  # Do not pass pkgs.dwm.override { conf = … }. `conf` replaces the
  # whole config.def.h and would drop symbols the diffs added
  # (togglefullscr, isfullscreen, …).
  #
  # Swallow, movestack, restartsig, attachbelow, and the fullscreen
  # (not actualfullscreen) diffs were dropped: they reject against this
  # 6.8 stack or fail to compile with the patches we keep. Alpha and
  # Xresources were skipped on purpose (no compositor; Nix is the
  # source of truth). Systray was skipped because trayer already draws
  # the tray in extraSessionCommands.
  flake.nixosModules.dwm =
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

      dwm-patched =
        (pkgs.dwm.override {
          patches = [
            # Every floating window is centered on the monitor. Dialogs
            # and Steam popups otherwise spawn at (0,0) or wherever the
            # client asked. Unlike the "center" patch this is not a
            # per-rule flag: all floats get it.
            (official "https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff" "1hzq9crj13vxy4720xn2g0398fgwr12n7gd8j8wm6i45b56w34aw")
            # New clients attach in the stack, not as the new master.
            # Vanilla dwm pushes the current master aside on every spawn
            # (the opposite of xmonad's insertPosition End Newer). The
            # focused window stays master; the new one lands beside it.
            (official "https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.6.diff" "0c1frbyzmsi80msc6ci64z0bsihh4kia368d9h1jfy9wnzac20bv")
            # Super+f should cover the whole monitor and hide the bar,
            # like xmonad's Toggle Full + ToggleStruts. Vanilla Super+f
            # only switches to the floating *layout*. The other
            # "fullscreen" patch needs pertag and conflicts here;
            # actualfullscreen is the 6.8-native one and adds
            # togglefullscr plus an isfullscreen rule field.
            (official "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-6.8.diff" "0sqdvaw93xg1vdiqqqqi88fx4nhplllg8y3fp429w8fgwawpwlkb")
            # Steam (and games it launches) send ConfigureNotify with
            # bogus x/y on every focus, so a floating Steam window walks
            # toward the bottom-right. This ignores those coordinates
            # for Steam class names only.
            (official "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff" "1ld1z3fh6p5f8gr62zknx3axsinraayzxw3rz1qwg73mx2zk5y1f")
            # Layout, mfact, nmaster and bar position are remembered per
            # tag. Vanilla dwm shares one layout across all tags, so
            # switching to monocle on tag 2 also monocles tag 1.
            (official "https://dwm.suckless.org/patches/pertag/dwm-pertag-6.2.diff" "042bp41sn8dvjkxnw1bclc268ik6g7cg5qalvx89xpmz5pqs0p85")
            # Publishes EWMH desktop properties (_NET_CURRENT_DESKTOP,
            # _NET_NUMBER_OF_DESKTOPS, _NET_DESKTOP_NAMES,
            # _NET_WM_DESKTOP, …) so pagers, trayer, and similar can see
            # tags as workspaces. Vanilla dwm tags are not EWMH desktops.
            (official "https://dwm.suckless.org/patches/ewmhtags/dwm-ewmhtags-6.8.diff" "09bgin8aic6khc0970zgivaacw95zz3yyhh7i6gjmg1aj51pj2x8")
            # Drop the 2px border when only one tiled window is visible
            # (same idea as xmonad smartBorders). A single client then
            # fills the monitor instead of sitting inside a purple frame.
            (official "https://dwm.suckless.org/patches/noborder/dwm-noborder-6.2.diff" "1q7g4ig120my7xlbybasf7jmsqd8g70z0cc79fp26bas7sb5zgwv")
          ];
        }).overrideAttrs
          (old: {
            # The official diffs already ran. This is not more patches: it is
            # search-and-replace on the resulting config.def.h so dwm matches
            # the xmonad session (Super, st, Dracula, same volume / screenshot
            # / clipmenu bindings).
            #
            # overrideAttrs keeps the package from dwm.override above and only
            # changes the build. postPatch is a shell snippet Nix runs after
            # applying the .diff files and before make. config.def.h is dwm's
            # config; the Makefile copies it to config.h and compiles that.
            #
            # (old.postPatch or "") keeps nixpkgs' own postPatch (empty unless
            # `conf` is set) and appends ours. The '' … '' is that script.
            #
            # substituteInPlace FILE --replace-fail OLD NEW rewrites every
            # OLD to NEW. --replace-fail dies if OLD is missing, so a future
            # dwm/nixpkgs change that moves these strings fails the rebuild
            # instead of shipping an unthemed window manager. A trailing \
            # continues the same substituteInPlace; each --replace-fail is
            # another pair.
            postPatch = (old.postPatch or "") + ''
                            # Super like xmonad (vanilla is Alt). 2px borders match
                            # xmonad borderWidth. resizehints 0: honor ICCCM size
                            # hints and terminals leave unused strips around the
                            # cell grid; 0 lets the client fill the tile. The
                            # "monospace:size=10" string is both fonts[] and
                            # dmenufont, so both become Fira Code.
                            #
                            # col_* feed the bar *and* dmenu_run. Selected border
                            # / bar stay Dracula purple (#bd93f9, xmonad
                            # focusedBorderColor). dmenu's selected background is
                            # overridden to #6272a4 so it matches the xmonad
                            # shellPrompt / clipmenu highlight, not the purple bar.
                            #
                            # Rules: Brave on tag 1 (1 << 0), Signal on tag 9
                            # (1 << 8), same as xmonad spawnOn "1" / "9". The
                            # extra isfullscreen column is from actualfullscreen.
                            # dwm has no spawnOn, so the rule is how windows land
                            # on the right tag after they map.
                            substituteInPlace config.def.h \
                              --replace-fail '#define MODKEY Mod1Mask' \
                                             '#define MODKEY Mod4Mask' \
                              --replace-fail 'static const unsigned int borderpx  = 1;' \
                                             'static const unsigned int borderpx  = 2;' \
                              --replace-fail 'static const int resizehints = 1;' \
                                             'static const int resizehints = 0;' \
                              --replace-fail '"monospace:size=10"' \
                                             '"FiraCode Nerd Font:size=10"' \
                              --replace-fail 'static const char col_gray1[]       = "#222222";' \
                                             'static const char col_gray1[]       = "#282a36";' \
                              --replace-fail 'static const char col_gray2[]       = "#444444";' \
                                             'static const char col_gray2[]       = "#44475a";' \
                              --replace-fail 'static const char col_gray3[]       = "#bbbbbb";' \
                                             'static const char col_gray3[]       = "#f8f8f2";' \
                              --replace-fail 'static const char col_gray4[]       = "#eeeeee";' \
                                             'static const char col_gray4[]       = "#f8f8f2";' \
                              --replace-fail 'static const char col_cyan[]        = "#005577";' \
                                             'static const char col_cyan[]        = "#bd93f9";' \
                              --replace-fail '-sb", col_cyan,' \
                                             '-sb", "#6272a4",' \
                              --replace-fail '{ "Firefox",  NULL,       NULL,       1 << 8,       0,           0,             -1 },' \
                                             '{ "Brave-browser", NULL,  NULL,       1 << 0,       0,           0,             -1 },
              	{ "Signal",          NULL,  NULL,       1 << 8,       0,           0,             -1 },'

                            # Key swaps have to happen in this order because
                            # --replace-fail matches the current file text.
                            # Super+Shift+q is kill in xmonad and quit in vanilla
                            # dwm: move quit to Super+Control+q first, then give
                            # Shift+q to killclient (which was Shift+c).
                            # Super+d is dmenu (xmonad M-d); vanilla Super+d is
                            # incnmaster -1, so that moves to Super+o first or
                            # the dmenu replace would hit the wrong line.
                            # Super+Return launches st (xmonad M-Return);
                            # vanilla uses Super+Shift+Return for spawn and
                            # Super+Return for zoom — swap those two.
                            # Super+f is actualfullscreen; vanilla Super+f is
                            # the floating layout, so that layout moves to
                            # Super+Shift+s (Shift+f is then free, and we
                            # already consumed it above).
                            substituteInPlace config.def.h \
                              --replace-fail '{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },' \
                                             '{ MODKEY|ControlMask,           XK_q,      quit,           {0} },' \
                              --replace-fail '{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },' \
                                             '{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },' \
                              --replace-fail '{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },' \
                                             '{ MODKEY,                       XK_o,      incnmaster,     {.i = -1 } },' \
                              --replace-fail '{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },' \
                                             '{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },' \
                              --replace-fail '{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },' \
                                             '{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },' \
                              --replace-fail '{ MODKEY,                       XK_Return, zoom,           {0} },' \
                                             '{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },' \
                              --replace-fail '{ MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },' \
                                             '{ MODKEY|ShiftMask,             XK_s,      setlayout,      {.v = &layouts[1]} },' \
                              --replace-fail '{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },' \
                                             '{ MODKEY,                       XK_f,      togglefullscr,  {0} },'

                            # Extra keys matching xmonad.hs, inserted just
                            # before the first TAGKEYS line (the only unique
                            # hook that is still in the file after the
                            # remaps). Super+arrows focus the stack the way
                            # xmonad's Navigation2D arrows do; movestack did
                            # not apply, so there is no Super+Shift+arrow swap.
                            #
                            # The NEW string is a shell single-quoted
                            # argument to --replace-fail, so a literal ' in
                            # the C source is written '"'"' (end quote,
                            # double-quoted ', reopen quote). SHCMD is
                            # /bin/sh -c: without those quotes around
                            # #RRGGBB, the shell treats # as a comment and
                            # clipmenu gets no colours.
                            substituteInPlace config.def.h \
                              --replace-fail '	TAGKEYS(                        XK_1,                      0)' \
                                             '	{ 0,                            XK_Print,  spawn,          SHCMD("flameshot gui") },
              	{ Mod1Mask,                     XK_c,      spawn,          SHCMD("clipmenu -nf '"'"'#F8F8F2'"'"' -nb '"'"'#282A36'"'"' -sb '"'"'#6272A4'"'"' -sf '"'"'#F8F8F2'"'"' -fn '"'"'monospace-10'"'"'") },
              	{ MODKEY,                       XK_F11,    spawn,          SHCMD("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-") },
              	{ MODKEY,                       XK_F12,    spawn,          SHCMD("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+") },
              	{ MODKEY,                       XK_Left,   focusstack,     {.i = -1 } },
              	{ MODKEY,                       XK_Right,  focusstack,     {.i = +1 } },
              	{ MODKEY,                       XK_Up,     focusstack,     {.i = -1 } },
              	{ MODKEY,                       XK_Down,   focusstack,     {.i = +1 } },
              	TAGKEYS(                        XK_1,                      0)'
            '';
          });
    in
    {
      # Confirmed on this flake's nixpkgs: enable, package,
      # extraSessionCommands. enable appends a LightDM session that
      # runs extraSessionCommands and then `dwm &`. package is what
      # ends up on PATH as `dwm`.
      services.xserver.windowManager.dwm = {
        enable = true;
        package = dwm-patched;
        # Same glue as xmonad.hs myStartupHook, minus spawnOn (dwm has
        # no equivalent without another patch). Brave / Signal then
        # land on the right tag via the rules above. Commands are
        # already on PATH from one-liners / flameshot / brave / st.
        extraSessionCommands = ''
          # User keyring → session keyring, for ssh-agent and friends.
          # Harmless if the link already exists.
          keyctl link @u @s 2>/dev/null || true
          # One trayer. Same flags as xmonad so the tray is the same
          # height / edge / Dracula tint. killall first so a leftover
          # from a previous session is not stacked on top.
          killall trayer 2>/dev/null || true
          trayer --height 26 --edge bottom --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282a36 &
          clipmenud &
          numlockx on
          setxkbmap -layout us,il -option grp:alt_shift_toggle
          kbdd &
          brave &
          signal-desktop &
          st &
          # dwm's bar text is whatever ROOT's WM_NAME is. xmobar stays
          # with xmonad; this loop is the dwm-native status. pkgs.xsetroot
          # (not the deprecated pkgs.xorg.xsetroot alias).
          while true; do
            ${pkgs.xsetroot}/bin/xsetroot -name "$(date '+%Y-%m-%d %H:%M')"
            sleep 15
          done &
        '';
      };
    };
}

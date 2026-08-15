{ inputs, ... }:
{
  # Vanilla nixpkgs dwm 6.8 plus official suckless.org diffs.
  # xmonad stays the LightDM default; this only adds a second session.
  # Swallow, movestack, restartsig, attachbelow, and the fullscreen
  # (not actualfullscreen) diffs were dropped: they reject against this
  # 6.8 stack or fail to compile with the patches we keep.
  flake.nixosModules.dwm =
    { pkgs, ... }:
    let
      official =
        url: sha256:
        pkgs.fetchurl {
          inherit url sha256;
        };

      dwm-patched =
        (pkgs.dwm.override {
          patches = [
            (official "https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff" "1hzq9crj13vxy4720xn2g0398fgwr12n7gd8j8wm6i45b56w34aw")
            (official "https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.6.diff" "0c1frbyzmsi80msc6ci64z0bsihh4kia368d9h1jfy9wnzac20bv")
            (official "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-6.8.diff" "0sqdvaw93xg1vdiqqqqi88fx4nhplllg8y3fp429w8fgwawpwlkb")
            (official "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff" "1ld1z3fh6p5f8gr62zknx3axsinraayzxw3rz1qwg73mx2zk5y1f")
            (official "https://dwm.suckless.org/patches/pertag/dwm-pertag-6.2.diff" "042bp41sn8dvjkxnw1bclc268ik6g7cg5qalvx89xpmz5pqs0p85")
            (official "https://dwm.suckless.org/patches/ewmhtags/dwm-ewmhtags-6.8.diff" "09bgin8aic6khc0970zgivaacw95zz3yyhh7i6gjmg1aj51pj2x8")
            (official "https://dwm.suckless.org/patches/noborder/dwm-noborder-6.2.diff" "1q7g4ig120my7xlbybasf7jmsqd8g70z0cc79fp26bas7sb5zgwv")
          ];
        }).overrideAttrs
          (old: {
            # The official diffs already ran. This is not more patches: it is
            # search-and-replace on the resulting config.def.h so dwm matches
            # the xmonad session (Super, st, Dracula, same volume / screenshot
            # / clipmenu bindings). Do not pass `conf`: that replaces the
            # whole file and would drop symbols the diffs added.
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
                            # Super like xmonad. 2px borders; resizehints 0 so terminals
                            # do not leave gaps. Fira Code matches st. Color slots feed
                            # both the bar and dmenu_run.
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

                            # Super+Shift+q is kill in xmonad. Move dwm's quit off that
                            # binding first so the next replace can take Shift+q for kill.
                            # Super+d is dmenu (xmonad M-d); Super+o keeps incnmaster -1.
                            # Super+Return launches st; Super+Shift+Return is zoom.
                            # Super+f is actualfullscreen; the old float layout moves to
                            # Super+Shift+s so Shift+f is free.
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

                            # Extra keys matching xmonad.hs (Print, clipmenu, volume, arrows).
                            # The NEW string is a shell single-quoted argument, so a
                            # literal ' in the C source is written '"'"'. Without those
                            # quotes, /bin/sh -c would treat #RRGGBB as a comment.
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
      services.xserver.windowManager.dwm = {
        enable = true;
        package = dwm-patched;
        extraSessionCommands = ''
          keyctl link @u @s 2>/dev/null || true
          killall trayer 2>/dev/null || true
          trayer --height 26 --edge bottom --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282a36 &
          clipmenud &
          numlockx on
          setxkbmap -layout us,il -option grp:alt_shift_toggle
          kbdd &
          brave &
          signal-desktop &
          st &
          while true; do
            ${pkgs.xsetroot}/bin/xsetroot -name "$(date '+%Y-%m-%d %H:%M')"
            sleep 15
          done &
        '';
      };
    };
}

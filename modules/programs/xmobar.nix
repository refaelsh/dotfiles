{ inputs, ... }:
{
  # Simple dendritic feature — exactly like mangohud / bat / eza
  flake.nixosModules.nixmobar =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.xmobar
        # BatteryP's critical action runs notify-send. dunst is the daemon
        # that actually displays it; libnotify is the client binary.
        pkgs.libnotify
      ];

      # X11 session. Wayland support would pull a second display stack for
      # a notification daemon that only needs to talk to xmonad and dwm.
      services.dunst = {
        enable = true;
        enableWayland = false;
      };

      system.activationScripts.xmobarrc = lib.stringAfter [ "users" ] ''
        cat > /home/refaelsh/.xmobarrc << 'EOF'
        Config {
          -- Use xft: with "Family-Size" syntax (very common for xmobar + Nerd Fonts).
          -- Main font is the Mono variant to keep layout names monospaced (prevent
          -- bar shifting on "us" <-> "il").
          -- Additional font is the regular variant at size 22 (tuned down from 28
          -- after 28 made icons huge; 20/24 were previously too small in earlier
          -- tests). This should give icons a reasonable size next to 14pt text.
          font            = "xft:FiraCode Nerd Font Mono-14"
        , additionalFonts = ["xft:FiraCode Nerd Font-14"]
        , bgColor         = "#282A36"
        , fgColor         = "#F8F8F2"
        , textOffset      = 2
        , verbose         = True
        , allDesktops     = True
        , lowerOnStart    = True
        , overrideRedirect = True
        , position        = BottomH 26
        , alpha           = 200
        , alignSep        = "}{"
        -- Volume uses %volume% (wpctl) rather than %alsa:default:Master%. The
        -- Alsa plugin opens the mixer once at startup; if PipeWire is not ready
        -- yet (common right after login), it stays stuck on N/A until xmobar is
        -- restarted. Polling wpctl retries every second and fills in once audio is up.
        , template        = "<hspace=8/>%XMonadLog% }{ %load%|%disku%|%diskio%|<fc=#bd93f9><fn=1></fn></fc> %wifi_signal%|%dynnetwork%|<fc=#bd93f9><fn=1>󰈐</fn></fc> %fan_rpm%|%multicoretemp%|%cpufreq%|%multicpu%|<fc=#bd93f9><fn=1></fn></fc> %kbd%|%memory% %swap%|%battery%|<fc=#bd93f9><fn=1></fn></fc> %volume%|<fc=#bd93f9><fn=1></fn></fc> %kernel_version%|%date%|%_XMONAD_TRAYPAD%"
        , commands        = 
            -- DiskIO, DynNetwork, Memory and Swap updated every 5s (instead of 1s)
            -- to reduce background CPU wakeups and process spawning.
            -- Date and MultiCpu kept at 1s for a responsive clock and live per-core CPU display.
            [ Run XMonadLog
            , Run DiskU [("/", "<fc=#bd93f9><fn=1>\xf0a0</fn></fc> <free>")] [] 50
            , Run DiskIO [("/", "<read><fc=#bd93f9> R</fc> <fc=#bd93f9>W</fc> <write>")] ["-t", "", "-w", "4"] 50
            -- Using filled black arrows (⬇ ⬆) instead of thin arrows (↓ ↑) for
            -- download/upload. These have thicker stems and heads for better visibility.
            , Run DynNetwork ["-t", "<fc=#bd93f9><fn=1>\x2b07</fn></fc><rx>KB/s <fc=#bd93f9><fn=1>\x2b06</fn></fc><tx>KB/s", "-w", "5"] 50
            , Run Memory ["-t", "<fc=#bd93f9><fn=1>\xE266</fn></fc> <usedratio>%"] 50
            , Run Swap ["-t", "<fc=#bd93f9>S</fc><usedratio>%"] 50
            , Run Kbd [("us", "us"), ("il", "il")]
            , Run CpuFreq ["-t", "<avg>GHz"] 50
            , Run MultiCoreTemp ["-t", "<fc=#bd93f9><fn=1>\xf2c9</fn></fc><avg>°", "-L", "60", "-H", "95", "-l", "white", "-n", "white", "-h", "red"] 50
            -- Resolve the Dell SMM fan via the platform device + glob so this
            -- survives /sys/class/hwmon/hwmonN renumbering across boots/kernels.
            , Run ComX "sh" ["-c", "cat /sys/devices/platform/dell_smm_hwmon/hwmon/hwmon*/fan1_input 2>/dev/null | head -n1"] "N/A" "fan_rpm" 50
            , Run MultiCpu ["-t", "<fc=#bd93f9><fn=1>\xf4bc</fn></fc> <vbar0><vbar1><vbar2><vbar3><vbar4><vbar5><vbar6><vbar7>", "-w", "99", "-L", "3", "-H", "50", "--normal", "green", "--high", "red"] 10
            , Run BatteryP ["BAT0"] ["-t", "<fc=#bd93f9><fn=1>󱊣</fn></fc><left>%", "-L", "10", "-H", "80", "-p", "3", "--", "-O", "<fc=green>On</fc> - ", "-i", "", "-L", "-15", "-H", "-5", "-l", "red", "-m", "blue", "-h", "green", "-a", "notify-send -u critical 'Battery running out!!'", "-A", "3"] 600
            -- PipeWire default sink volume via wpctl (same path as the Mod+F11/F12
            -- bindings). Refresh every 1s so the bar catches key presses quickly
            -- and recovers after boot once WirePlumber has a default sink.
            , Run ComX "sh" ["-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf \"%d%%\", $2 * 100 + 0.5}'"] "N/A" "volume" 10
            , Run Date "%a %_d %b %H:%M:%S" "date" 10
            , Run Load ["-t", "<fc=#bd93f9><fn=0>L</fn></fc><load1>", "-L", "1", "-H", "3", "-d", "2"] 300
            -- IN-USE is "*" on the associated BSS. Without that filter the
            -- first row is whichever AP nmcli listed first, not the one in use.
            -- --rescan no reads the cache; a rescan every 5s stalls the radio.
            , Run ComX "sh" ["-c", "nmcli -t -f IN-USE,SIGNAL device wifi list --rescan no | awk -F: '$1==\"*\" {print $2; found=1; exit} END {exit !found}'"] "N/A" "wifi_signal" 50
            , Run Com "uname" ["-r"] "kernel_version" 3600
            , Run XPropertyLog "_XMONAD_TRAYPAD"
            ]
        }
        EOF

        chown refaelsh:users /home/refaelsh/.xmobarrc
        chmod 644 /home/refaelsh/.xmobarrc

        # The Dell is a second Xinerama head at x=1920. xmonad puts an empty
        # workspace there, and an empty workspace paints nothing, so the panel
        # is black. This bar sits on that head and shows its workspace.
        cat > /home/refaelsh/.xmobarrc-dell << 'EOF'
        Config {
          font            = "xft:FiraCode Nerd Font Mono-14"
        , additionalFonts = ["xft:FiraCode Nerd Font-14"]
        , bgColor         = "#282A36"
        , fgColor         = "#F8F8F2"
        , textOffset      = 2
        , allDesktops     = True
        , lowerOnStart    = True
        , overrideRedirect = True
        , position        = OnScreen 1 (BottomH 26)
        , alpha           = 200
        , alignSep        = "}{"
        , template        = " %XMonadLog% }{ %date% "
        , commands        =
            [ Run XMonadLog
            , Run Date "%a %_d %b %H:%M:%S" "date" 10
            ]
        }
        EOF
        chown refaelsh:users /home/refaelsh/.xmobarrc-dell
        chmod 644 /home/refaelsh/.xmobarrc-dell
      '';
    };
}

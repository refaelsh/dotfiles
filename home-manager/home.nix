{
  # programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  # home.username = "refaelsh";
  # home.homeDirectory = "/home/refaelsh";

  imports = [
    ./alacritty.nix
    ./git.nix
    ./fzf.nix
    ./lf.nix
    ./librewolf.nix
    ./kitty.nix
    ./mangohud.nix
    ./nixmobar.nix
    ./starship.nix
    ./termonad.nix
    ./wezterm.nix
    # ./xmobar.nix
    ./zsh.nix
  ];

  programs.nixmobar = {
    enable = true;
    font = "Fira Code 13";
    additionalFonts = [ "Fira Code 22" ];
    bgColor = "#282A36";
    fgColor = "#F8F8F2";
    textOffset = 2;
    verbose = true;
    allDesktops = true;
    lowerOnStart = true;
    overrideRedirect = true;
    position = "BottomH 26";
    alpha = 200;
    alignSep = "}{";
    template = "<hspace=8/>%XMonadLog% }{ %load%|%disku%|%diskio%|<fc=#bd93f9><fn=1></fn></fc>%wifi_signal%|%dynnetwork%|<fc=#bd93f9><fn=1>󰈐</fn></fc>%cat0%|%multicoretemp%|%cpufreq%|%multicpu%|<fc=#bd93f9><fn=1></fn></fc>%kbd%|%memory% %swap%|%battery%|%alsa:default:Master%|<fc=#bd93f9><fn=1></fn></fc>%kernel_version%|%date%|%_XMONAD_TRAYPAD%";
    commands = # haskell
      ''
        Run XMonadLog,
        Run DiskU [("/", "<fc=#bd93f9><fn=1>\xf0a0</fn></fc> <free>")] [] 50,
        Run DiskIO [("/", "<read><fc=#bd93f9> R</fc> <fc=#bd93f9>W</fc> <write>")] ["-t", "", "-w", "4"] 10,
        Run DynNetwork ["-t", "<rx>KB/s<fc=#bd93f9><fn=1>\x1F89B</fn></fc><fc=#bd93f9><fn=1>\x1F899</fn></fc><tx>KB/s", "-w", "5"] 10,
        Run Memory ["-t", "<fc=#bd93f9><fn=1>\xE266</fn></fc><usedratio>%"] 10,
        Run Swap ["-t", "<fc=#bd93f9>S</fc><usedratio>%"] 10,
        Run Kbd [],
        Run CpuFreq ["-t", "<avg>GHz"] 50,
        Run MultiCoreTemp ["-t", "<fc=#bd93f9><fn=1>\xf2c9</fn></fc><avg>°", "-L", "60", "-H", "95", "-l", "white", "-n", "white", "-h", "red"] 50,
        Run CatInt 0 "/sys/class/hwmon/hwmon4/fan1_input" [] 50,
        Run MultiCpu ["-t", "<fc=#bd93f9><fn=1>\xf4bc</fn></fc> <vbar0><vbar1><vbar2><vbar3><vbar4><vbar5><vbar6><vbar7>", "-w", "99", "-L", "3", "-H", "50", "--normal", "green", "--high", "red"] 10,
        Run BatteryP ["BAT0"] ["-t", "<fc=#bd93f9><fn=1>󱊣</fn></fc><left>%", "-L", "10", "-H", "80", "-p", "3", "--", "-O", "<fc=green>On</fc> - ", "-i", "", "-L", "-15", "-H", "-5", "-l", "red", "-m", "blue", "-h", "green", "-a", "notify-send -u critical 'Battery running out!!'", "-A", "3"] 600,
        Run Alsa "default" "Master" ["-t", "<fc=#bd93f9><fn=1>\xf028</fn></fc> <volume>%"],
        Run Date "%a %_d %b %H:%M:%S" "date" 10,
        Run Load ["-t", "<fc=#bd93f9><fn=0>L</fn></fc><load1>", "-L", "1", "-H", "3", "-d", "2"] 300,
        Run ComX "nmcli" ["-t", "-f", "SIGNAL", "dev", "wifi"] "N/A" "wifi_signal" 50,
        Run Com "uname" ["-r"] "kernel_version" 3600,
        Run XPropertyLog "_XMONAD_TRAYPAD"
      '';
  };
}

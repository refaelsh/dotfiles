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
    ./nixmobar.nix
    ./mangohud.nix
    ./starship.nix
    ./termonad.nix
    ./wezterm.nix
    ./xmobar.nix
    ./zsh.nix
  ];

  programs.nixmobar = {
    enable = true;
    commands = ''
      Run XMonadLog,
      Run DiskU [("/", "<fc=#bd93f9><fn=1>\xf0a0</fn></fc> <free>")] [] 50,
      Run DiskIO [("/", "<read><fc=#bd93f9> R</fc> <fc=#bd93f9>W</fc> <write>")] ["-t", "", "-w", "4"] 10,
      Run DynNetwork ["-t", "<rx>KB/s<fc=#bd93f9><fn=1>\x1F89B</fn></fc><fc=#bd93f9><fn=1>\x1F899</fn></fc><tx>KB/s", "-w", "5"] 10,
      Run Memory ["-t", "<fc=#bd93f9><fn=1>\xE266</fn></fc><usedratio>%"] 10,
      Run Swap ["-t", "<fc=#bd93f9>S</fc><usedratio>%"] 10,
      Run Kbd [],
    '';
  };
}

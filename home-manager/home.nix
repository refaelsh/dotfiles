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
  };
}

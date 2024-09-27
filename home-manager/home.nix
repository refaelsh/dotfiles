{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  # home.username = "refaelsh";
  # home.homeDirectory = "/home/refaelsh";

  imports = [
    ./alacritty.nix
    ./git.nix
    ./fzf.nix
    ./librewolf.nix
    # ./kitty.nix
    ./mangohud.nix
    ./starship.nix
    ./termonad.nix
    ./wezterm.nix
    ./xmobar.nix
    ./zsh.nix
  ];
}
# sdfsdfsd

{ inputs, ... }:
{
  # programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  # home.username = "refaelsh";
  # home.homedirectory = "/home/refaelsh";

  imports = [
    ./alacritty.nix
    ./git.nix
    ./fzf.nix
    ./lf.nix
    ./librewolf.nix
    ./kitty.nix
    ./mangohud.nix
    inputs.nixmobar.homeModules.nixmobar
    ./nixmobar.nix
    ./starship.nix
    ./termonad.nix
    ./wezterm.nix
    # ./xmobar.nix
    ./zsh.nix
  ];

}

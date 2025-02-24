{ self, inputs, nixmobar, ... }:
{
  # programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  # home.username = "refaelsh";
  # home.homedirectory = "/home/refaelsh";

  imports = [
    ./alacritty.nix
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./fzf.nix
    ./lf.nix
    ./librewolf.nix
    ./kitty.nix
    ./mangohud.nix
    inputs.nixmobar.homeModules.mainmodule
    ./nixmobar.nix
    ./starship.nix
    ./termonad.nix
    ./wezterm.nix
    # ./xmobar.nix
    ./zsh.nix
  ];

}

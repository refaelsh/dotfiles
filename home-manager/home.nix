{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  imports = [
    ./main.nix
    ./fzf.nix
    ./librewolf.nix
    ./starship.nix
    ./wezterm.nix
    ./xmobar.nix
    ./zsh.nix
  ];
}

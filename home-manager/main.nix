{
  programs.home-manager.home.stateVersion = "24.05";
  home-manager.users.refaelsh = {
    modules = [
      ./alacritty.nix
      ./git.nix
      ./fzf.nix
      ./librewolf.nix
      ./kitty.nix
      ./mangohud.nix
      ./starship.nix
      ./termonad.nix
      ./wezterm.nix
      ./xmobar.nix
      ./zsh.nix
    ];
  };
}

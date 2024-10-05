{
  self,
  inputs,
  nixmobar,
  ...
}:
{
  # programs.home-manager.enable = true;
  home.stateversion = "24.05";
  # home.username = "refaelsh";
  # home.homedirectory = "/home/refaelsh";

  imports = [
    # inputs.nixmobar.homemodules.nixmobar
    # inputs.self.homemodules.nixmobar
    inputs.nixmobar.homemodules.mainmodule
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

}

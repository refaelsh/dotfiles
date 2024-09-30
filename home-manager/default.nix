{ nixmobar, ... }:
{

  imports = [ nixmobar.homeModules.nixmobar ];
  home-manager.users.refaelsh = import ./home.nix;
}

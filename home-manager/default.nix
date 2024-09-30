{ inputs, nixmobar, ... }:
{
  # imports = [ nixmobar.homeModules.nixmobar ];
  extraSpecialArgs = {
    inherit inputs; # or specific values from inputs
  };
  home-manager.users.refaelsh = import ./home.nix;
}

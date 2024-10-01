{ inputs, nixmobar, ... }:
{
  # imports = [ nixmobar.homeModules.nixmobar ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users.refaelsh = import ./home.nix;
  };
}

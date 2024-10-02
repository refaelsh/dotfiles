{ inputs, nixmobar, ... }:
{
  # imports = [ nixmobar.homeModules.nixmobar ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs nixmobar;
    };
    users.refaelsh = import ./home.nix;
  };
}

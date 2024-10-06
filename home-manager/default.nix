{ inputs, ... }:
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users.refaelsh = import ./home.nix;
  };
}

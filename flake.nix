{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:refaelsh/dotfiles?dir=home-manager";
    nixvim.url = "github:refaelsh/dotfiles?dir=nixvim";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        myNixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };

          modules = [
            ./nixos/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            # self.nixosModules.home-manager
            {
              environment.systemPackages = [
                inputs.nixvim.packages.${system}.default
                # inputs.home-manager.packages.${system}.default
              ];
            }
          ];
        };
      };
    };
}

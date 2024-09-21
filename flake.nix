{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "./nixvim";
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
            ./configuration.nix
            {
              environment.systemPackages = [
                inputs.nixvim.packages.${system}.default
              ];

              home-manager = {
                users.refaelsh = import ./home-manager/home.nix;
              };
            }
          ];
        };
      };
    };
}

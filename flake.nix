{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            inputs.nixvim.nixosModules.nixvim
            ./nixvim/main.nix
            inputs.home-manager.nixosModules.home-manager
            {
              environment.systemPackages = [
                # inputs.nixvim.packages.${system}.default
                # inputs.brave.packages.${system}.default
              ];

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.users.refaelsh = import ./home-manager/home.nix;
            }
          ];
        };
      };
    };
}

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
    # nixmobar.url = "./nixmobar";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      homeModules.nixmobar = import ./default.nix;

      nixosConfigurations = {
        myNixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };

          modules = [
            ./nixos/configuration.nix

            inputs.nixvim.nixosModules.nixvim
            ./nixvim

            inputs.home-manager.nixosModules.home-manager
            ./home-manager

            # inputs.nixmobar.homeModules.nixmobar
            inputs.self.homeModules.nixmobar

            {
              environment.systemPackages = [
                # inputs.nixvim.packages.${system}.default
                # inputs.brave.packages.${system}.default
              ];

            }
          ];
        };
      };
    };
}

{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # home-manager.url = "github:refaelsh/dotfiles?dir=home-manager";
    home-manager.url = "./home-manager";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brave.url = "./brave";
    xmonad.url = "./xmonad";
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

          imports = [ <nixvim>.nixosModules.nixvim ];

          modules = [
            ./nixos/configuration.nix
            ./nixvim/config
            inputs.home-manager.nixosModules.home-manager
            inputs.xmonad.nixosModules.xmonad
            {
              environment.systemPackages = [
                # inputs.nixvim.packages.${system}.default
                inputs.brave.packages.${system}.default
              ];
            }
          ];
        };
      };
    };
}

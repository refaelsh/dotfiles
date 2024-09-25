{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm.url = "github:wez/wezterm?dir=nix";
    # nixvim.url = "github:refaelsh/dotfiles?dir=nixvim";
    inputs.nixvim = {
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

            {
              environment.systemPackages = [
                inputs.nixvim.packages.${system}.default
              ];
            }

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.users.refaelsh = import ./home-manager/home.nix;
            }

            inputs.nixvim.nixosModules.nixvim
            { modules = [./nixvim/config ]; }
          ];
        };
      };
    };
}

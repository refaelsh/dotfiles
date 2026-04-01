{
  description = "Refael's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    host = import ./modules/hosts/refael-nixos.nix {
      inherit inputs;
      inherit (nixpkgs) lib;
    };
  in
  {
    # Both the modules and the configuration now come from the single unified file
    nixosModules = host.flake.nixosModules;
    nixosConfigurations = host.flake.nixosConfigurations;
  };
}

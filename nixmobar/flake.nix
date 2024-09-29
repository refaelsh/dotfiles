{
  description = "Xmobar configuration module for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      mkHomeConfig =
        username:
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [
            ./default.nix # Path to your module file
          ];
        };
    in
    {
      # nixosModules = {
      #   nixmobar = import ./default.nix;
      # };

      nixosModules.nixmobar =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [
            home-manager.nixosModules.home-manager
            {
              home-manager.users = lib.mapAttrs (name: value: mkHomeConfig name) config.users.users; # This dynamically sets up home-manager for all defined users
            }
          ];
        };
    };
}

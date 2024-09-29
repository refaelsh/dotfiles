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
    in
    {
      # homeManagerModules= {
      #   nixmobar = import ./default.nix;
      # };

      homeConfigurations = {
        "yourUsername@yourHostname" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Or your system architecture
          modules = [
            ./default.nix # Path to your home-manager configuration
          ];
        };
      };
    };
}

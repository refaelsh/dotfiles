{
  description = "Xmobar configuration module for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
      in
      # pkgs = import nixpkgs {
      #   inherit system;
      # };
      {
        # The module can be imported in home-manager configurations
        homeModules.nixmobar = import ./default.nix;

        # Optionally, provide a default package if your module has an associated tool
        # defaultPackage = pkgs.callPackage ./path-to-your-package {};
      }
    );
}

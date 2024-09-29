{
  description = "Xmobar configuration module for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      # The module can be imported in home-manager configurations
      homeModules.x86_64-linux.nixmobar = import ./default.nix;

      # Optionally, provide a default package if your module has an associated tool
      # defaultPackage = pkgs.callPackage ./path-to-your-package {};
    };
}

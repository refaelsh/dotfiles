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
      # You might want to export homeManagerModules directly here
      default.homeManagerModules = {
        nixmobar = import ./default.nix;
      };
      # If you need to expose other outputs like nixosConfigurations or devShells,
      # you would add them here directly, not wrapped in another function.
    };
}

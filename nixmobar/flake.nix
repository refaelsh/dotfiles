{
  description = "Xmobar configuration module for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      ...
    }:
    {
      homeModules.mainmodule = import ./default.nix;
    };
}

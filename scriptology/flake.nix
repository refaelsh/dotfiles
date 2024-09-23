{
  description = "A collection of shell scripts for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        scripts = {
          # Example script, replace or add your own scripts here
          helloScript = pkgs.writeShellScriptBin "hello" ''
            echo "Hello from Nix flake!"
          '';
        };
      in
      {
        packages = {
          default = pkgs.symlinkJoin {
            name = "scripts";
            paths = builtins.attrValues scripts;
          };
        };
      }
    );
}

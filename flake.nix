{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # wezterm.url = "github:wez/wezterm?dir=nix";
    bbb.url = "github:refaelsh/dotfiles?dir=bla";
    nixvim.url = "github:refaelsh/dotfiles?dir=nixvim";
  };

  outputs =
    { nixpkgs, ... }@inputs:
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
                inputs.bbb.packages.${system}.default
              ];
            }
          ];
        };
      };
    };
}

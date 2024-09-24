{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm.url = "github:wez/wezterm?dir=nix";
    # home-manager.url = "github:refaelsh/dotfiles?dir=bla";
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
            inputs.home-manager.nixosModules.home-manager
            # inputs.home-manager.nixosModules.home-manager
            # inputs.home-manager.homeConfigurations.refaelsh
            # inputs.home-manager.nixosModules.home-manager
            # inputs.home-manager.nixosModules.home-manager
            # inputs.home-manager.homeConfigurations.refaelsh
            # inputs.home-manager.homeConfigurations.homeManagerModules.bbb
            # inputs.home-manager.homeManagerModules.bbb
            {
              environment.systemPackages = [
                inputs.nixvim.packages.${system}.default
                # inputs.home-manager.package.${system}.default
                # inputs.home-manager.homeConfigurations.default
                # inputs.home-manager.packages.default.x86_64-linux
              ];

              home-manager = {
                users.refaelsh = import ./home-manager/home.nix;
              };
            }
          ];
        };
      };
    };
}

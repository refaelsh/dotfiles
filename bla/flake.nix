{
  description = "Standalone Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs =
  #   {
  #     self,
  #     nixpkgs,
  #     home-manager,
  #     ...
  #   }:
  #   {
  #     homeConfigurations."refaelsh" = home-manager.lib.homeManagerConfiguration {
  #
  #       # Your home-manager modules go here
  #       modules = [
  #         ./home.nix # Assuming your configuration is in home.nix
  #         # Add other modules here
  #       ];
  #     };
  #
  #     packages.x86_64-linux.default =
  #       self.homeConfigurations."refaelsh".config.home.packages.myPackage;
  #   };
  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      homeManagerConfigurations.x86_64-linux = {
        bbb = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules = [
            ./home.nix # Assuming your configuration is in home.nix
            # Add other modules here
          ];

        };
      };
    };
}

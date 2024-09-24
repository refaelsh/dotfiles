{
  description = "Standalone Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    }:
    {
      homeConfigurations = {
        standalone = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Adjust the system if necessary
          modules = [
            ./home.nix # Your home-manager configuration file
          ];
        };
      };

      nixosModules.default = {
        modules = [
          # ./home.nix # Your home-manager configuration file
        ];

      };

      # If you want to make the home-manager module directly accessible:
      packages.x86_64-linux.default = self.homeConfigurations.standalone.activationPackage;

      nixosConfigurations = {
        myNixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.myuser = import ./home-configuration.nix;
            }
          ];
        };
      };
    };
}

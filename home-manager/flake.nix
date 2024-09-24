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
            ./home.nix
          ];
        };
      };

      packages.x86_64-linux.default = self.homeConfigurations.standalone.activationPackage;
    };
}

{
  description = "Standalone Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs =
    {
      self,
    }@inputs:
    {
      specialArgs = {
        inherit inputs;
      };
      homeConfigurations = {

        standalone = self.home-manager.lib.homeManagerConfiguration {
          pkgs = self.nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home.nix
          ];
        };
      };

      packages.x86_64-linux.default = self.homeConfigurations.standalone.activationPackage;
    };
}

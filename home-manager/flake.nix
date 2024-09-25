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
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      homeConfigurations = {
        specialArgs = {
          inherit inputs;
        };

        standalone = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./home.nix
          ];
        };
      };

      packages.x86_64-linux.default = self.homeConfigurations.standalone.activationPackage;
    };
}

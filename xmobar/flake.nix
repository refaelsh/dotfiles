{
  description = "Xmobar configuration module for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, lib, nixpkgs, home-manager }: {
    homeManagerModules.xmobar = import ./xmobar-module.nix;

    homeManagerModules.xmobar = {
      imports = [ self.nixosModules.xmobar ];
      config = lib.mkIf config.xmobar.enable {
        home.packages = [ pkgs.xmobar ];
      };
    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.xmobarConfig;

    packages.x86_64-linux.xmobarConfig = home-manager.lib.homeManagerConfiguration {
      configuration = { config, pkgs, ... }: {
        imports = [ self.homeManagerModules.xmobar ];
        xmobar.enable = true;  # Here you would typically set your config or use defaults
      };
      system = "x86_64-linux";
      homeDirectory = "/home/user";  # Adjust as necessary
      username = "user";  # Adjust as necessary
    };
  };
}

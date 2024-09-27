{
  description = "Standalone Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosModules.xmonad = {
        services.xserver.windowManager.xmonad = {
          enable = true;
          enableConfiguredRecompile = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.xmobar
          ];
          config = builtins.readFile ./xmonad.hs;
        };
      };

    };
}

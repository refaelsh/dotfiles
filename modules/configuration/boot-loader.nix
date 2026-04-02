{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/boot-loader.nix
  flake.nixosModules.boot-loader =
    { ... }:
    {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
      };
    };
}

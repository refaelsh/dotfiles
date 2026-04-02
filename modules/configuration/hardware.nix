{ inputs, pkgs, ... }:

{
  flake.nixosModules.hardware = { ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;
        bluetooth = {
          enable = false;
          powerOnBoot = false;
        };
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
            libvdpau-va-gl
          ];
        };
      };
    };
}

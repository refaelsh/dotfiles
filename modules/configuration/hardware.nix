{ inputs, ... }:
{
  flake.nixosModules.hardware =
    { pkgs, ... }:
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
            # Comet Lake (UHD 620) uses the iHD stack. intel-vaapi-driver is
            # the older i965 backend; leaving both installed lets some apps
            # pick i965 and break hardware decode.
            intel-media-driver
            libvdpau-va-gl
          ];
        };
      };
    };
}

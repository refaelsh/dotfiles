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
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };
    # keyboard.zsa.enable = true;
  };
}

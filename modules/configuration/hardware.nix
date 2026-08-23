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

      # PSR on this Comet Lake eDP introduces frame-pacing stutter, worse when
      # the 60 Hz panel is cloned with the 120 Hz HDMI monitor. Turning it off
      # keeps scanout consistent; the cost is a bit more display power.
      boot.kernelParams = [ "i915.enable_psr=0" ];

      # QCA9377 is a Wi-Fi+BT combo. bluetoothd is already off, but the
      # USB BT function (0cf3:e009) still binds btusb and keeps the BT
      # radio alive, which fights the 2.4 GHz side of the same chip.
      boot.blacklistedKernelModules = [
        "btusb"
        "btintel"
        "btrtl"
        "btbcm"
        "btmtk"
        "bluetooth"
      ];

      # QCA9377 (ath10k_pci at 02:00.0) adds tens-to-hundreds of ms of
      # extra latency when PCI ASPM L1 is left on. Disable L1 only on
      # that device so NVMe ASPM is untouched.
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x168c", ATTR{device}=="0x0042", TEST=="link/l1_aspm", ATTR{link/l1_aspm}="0"
      '';
    };
}

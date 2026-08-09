{ inputs, ... }:
{
  flake.nixosModules.hardware-configuration =
    { config, lib, ... }:
    {
      imports = [ (inputs.nixpkgs + "/nixos/modules/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/bea35ff9-b9e5-4446-aae5-a32eeb740d8e";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/4800-9EA8";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      # Disk swap is a last-resort safety net only. zram (higher priority, in
      # compressed RAM) is preferred; once the kernel starts writing meaningful
      # amounts here, interactive latency collapses (tab/desktop switches hitch).
      # Keep it mounted so OOM is delayed under extreme pressure, but treat any
      # sustained use as a signal to free RAM (close Steam / cull Brave tabs).
      swapDevices = [
        {
          device = "/dev/disk/by-uuid/6edb503d-8105-4483-9d00-edf430bba983";
          priority = -1; # Very low priority → zram is strongly preferred
        }
      ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

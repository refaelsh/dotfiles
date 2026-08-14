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
        # Skip atime updates. relatime still dirties inodes on the read-heavy
        # Nix store (once per day per file), which is extra flash traffic on
        # this 256 GB NVMe for no benefit.
        options = [ "noatime" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/4800-9EA8";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      # Disk swap is a last-resort safety net only. zram (priority 5, in
      # compressed RAM) is preferred; once the kernel starts writing meaningful
      # amounts here, interactive latency collapses (tab/desktop switches hitch).
      # Keep it mounted so OOM is delayed under extreme pressure, but treat any
      # sustained use as a signal to free RAM (close Steam / cull Brave tabs).
      #
      # priority must be 0–32767 (NixOS / swapon). -1 is the "use default"
      # sentinel and is remapped by the kernel (currently to -2), so it does
      # not mean "lowest". 0 is the lowest explicit value and stays below zram.
      # discardPolicy=once TRIMs unused swap blocks at swapon so this 8.8 G
      # partition does not sit forever outside the drive's free-block pool.
      swapDevices = [
        {
          device = "/dev/disk/by-uuid/6edb503d-8105-4483-9d00-edf430bba983";
          priority = 0;
          discardPolicy = "once";
        }
      ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

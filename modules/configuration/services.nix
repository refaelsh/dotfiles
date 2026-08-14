{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/services.nix
  flake.nixosModules.services =
    { ... }:
    {
      services = {
        # hledger-web.enable = true;
        libinput.enable = true;
        thermald.enable = true;

        # Pull Dell BIOS, ME, and NVMe firmware from LVFS. This laptop has
        # no other firmware-update path; without fwupd those updates never
        # reach the machine.
        fwupd.enable = true;
        gvfs.enable = true;
        udisks2.enable = true;
        devmon.enable = true;

        # Enable periodic TRIM on the SSD. The NVMe drive maintains better
        # long-term write performance when the firmware can regularly discard
        # unused blocks instead of running out of clean flash for new writes.
        fstrim.enable = true;

        # SMART monitoring for the SK hynix BC501. This OEM NVMe has a
        # modest endurance rating; warn on the console if the drive reports
        # failing attributes instead of discovering wear only after I/O errors.
        smartd = {
          enable = true;
          notifications.wall.enable = true;
        };

        # Cap persistent journal growth from GUI/Electron apps (Brave, Signal,
        # Zoom, etc.) so logs do not fill disk or add constant background I/O.
        # Written as plain journald.conf keys under [Journal].
        journald.extraConfig = ''
          SystemMaxUse=500M
          SystemKeepFree=1G
          MaxFileSec=1month
        '';

        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;

          # JACK is disabled. It starts an additional real-time capable daemon
          # (and requires rtkit privileges) that is only needed for low-latency
          # professional audio production. Normal desktop use, gaming (Steam),
          # and general multimedia do not benefit from it and pay a small
          # constant overhead in processes and scheduling.
          jack.enable = false;
        };

        displayManager = {
          autoLogin = {
            enable = true;
            user = "refaelsh";
          };
          defaultSession = "none+xmonad";
          # defaultSession = "niri";
        };

        xserver = {
          enable = true;
          resolutions = [
            {
              x = 1920;
              y = 1080;
            }
          ];
          xkb = {
            variant = "";
            layout = "us";
          };
          displayManager.lightdm.enable = true;
          windowManager.xmonad = {
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

      # Keep crash dumps but bound their flash use. Chrome/Brave child
      # processes have been writing cores here; unbounded Storage=external
      # would keep growing /var/lib/systemd/coredump.
      systemd.coredump.extraConfig = ''
        Storage=external
        ProcessSizeMax=32M
        MaxUse=50M
        KeepFree=1G
      '';
    };
}

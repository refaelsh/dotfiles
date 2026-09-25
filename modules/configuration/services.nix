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
        # gvfs already turns udisks2 on and automounts removable disks.
        # devmon/udevil does the same job and the two race on insert.
        udisks2.enable = true;

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
        journald.settings.Journal = {
          SystemMaxUse = "500M";
          SystemKeepFree = "1G";
          MaxFileSec = "1month";
        };

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
          # The Dell S2721HGF on HDMI-1 advertises a 144 Hz detailed
          # timing, but the UHD 620 HDMI link only accepts modes up to
          # 120 Hz. The Modes line above names 1920x1080 with no rate,
          # and the server then keeps the 60 Hz timing it also uses for
          # the internal panel. A monitor section whose identifier is
          # the output name is applied only to HDMI-1, and only while
          # that output is connected. The modeline is the 120 Hz timing
          # the driver already probed. The sync ranges are the panel's
          # EDID limits, so that 120 Hz mode is not rejected.
          # Fullscreen clients and the system tray follow the primary
          # output. The internal panel is 60 Hz, so the Dell is primary
          # while it is connected. With the cable unplugged this section
          # is not used and the laptop panel remains the primary.
          extraConfig = ''
            Section "Monitor"
              Identifier "HDMI-1"
              HorizSync 30-170
              VertRefresh 48-144
              Modeline "1920x1080_120" 297.00 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
              Option "PreferredMode" "1920x1080_120"
              Option "Primary" "true"
            EndSection
          '';
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
      systemd.coredump.settings.Coredump = {
        Storage = "external";
        ProcessSizeMax = "32M";
        MaxUse = "50M";
        KeepFree = "1G";
      };
    };
}

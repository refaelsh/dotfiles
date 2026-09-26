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
          # Display choices for the Dell S2721HGF on this Vostro 3590's
          # HDMI-1, driven by the UHD 620 (display version 9). When the
          # laptop, the panel, or the port changes, re-check every line
          # below against the new EDID and the new output name.
          #
          # Refresh and resolution are configured here. Native resolution
          # is 1920x1080 on both panels. The Dell's EDID preferred timing
          # is 144 Hz at 339.9 MHz. This HDMI 1.4b port stops at 300 MHz,
          # so the fastest mode the driver offers is 120 Hz at 297 MHz.
          # The modeline is that timing. The sync ranges are the panel's
          # EDID limits, so the 120 Hz mode is kept. The Modes line names
          # 1920x1080 with no rate; without a per-output preference the
          # server keeps the 60 Hz timing it also uses for the internal
          # panel. The section applies only while HDMI-1 is connected.
          #
          # The Dell is primary while connected, so fullscreen clients
          # and the tray follow the 120 Hz output. The internal panel is
          # 60 Hz. With the cable unplugged this section is unused and
          # the laptop panel remains primary.
          #
          # These were checked and left unset:
          # HDR. The EDID has no HDR metadata block, and this X11 session
          # has no HDR switch.
          # Color profile. The EDID primaries and gamma 2.2 match sRGB.
          # No measured ICC is applied. The X gamma ramp stays at 1.0.
          # A generic sRGB file would not move the picture.
          # Brightness. The Dell stores its own slider and was already
          # near a third of the scale (350 cd/m² panel, about 120 cd/m²).
          # The laptop backlight is saved by systemd-backlight on this
          # machine, at half of intel_backlight's maximum.
          # Variable refresh. The EDID advertises FreeSync from 48 to
          # 144 Hz. Display version 9 does not implement it; the driver
          # only does so from version 11, and no connector exposes VRR.
          # Response time. OSD only: Fast, Super Fast, Extreme, MPRT.
          # Super Fast is the middle overdrive step. Extreme overshoots.
          # MPRT strobes the backlight and needs 120 Hz or higher. DDC
          # does not expose this control.
          # Cable. This chassis has HDMI 1.4b and VGA, and no DisplayPort
          # plug. The link is already at 297 MHz, which is the port's
          # ceiling, so a faster cable cannot carry the 339.9 MHz timing.
          # Calibration. No meter is attached. An EDID-derived ICC is
          # not a measurement, so no profile is loaded.
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

{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/services.nix
  flake.nixosModules.services =
    { pkgs, ... }:
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

        # The laptop panel is 60 Hz and the Dell HDMI monitor is 120 Hz.
        # Leaving them both at +0+0 clones one desktop onto both timings and
        # the picture judders. autorandr places the Dell to the right when
        # its EDID is present, and leaves the laptop alone when it is not.
        # The lid switch reads closed even with the panel on, so matching
        # has to ignore the lid or the internal output disappears from the
        # detected layout.
        autorandr = {
          enable = true;
          ignoreLid = true;
          defaultTarget = "laptop";
          profiles = {
            laptop = {
              fingerprint."eDP-1" = "00ffffffffffff0009e5020800000000011c0104952213780a24109759548e271e5054000000010101010101010101010101010101019c3b8010713850403020360058c11000001a2e2c80de703814406464440558c11000001a000000fe004d39503734804e5431354e3431000000000000412196001000000a010a20200059";
              config."eDP-1" = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "1920x1080";
                rate = "60.01";
              };
            };
            "dell-s2721hgf" = {
              fingerprint = {
                "eDP-1" = "00ffffffffffff0009e5020800000000011c0104952213780a24109759548e271e5054000000010101010101010101010101010101019c3b8010713850403020360058c11000001a2e2c80de703814406464440558c11000001a000000fe004d39503734804e5431354e3431000000000000412196001000000a010a20200059";
                "HDMI-1" = "00ffffffffffff0010ace84157545a43041f0103803c22782aee95a3544c99260f5054a54b00d1c0b30081808100714f010101010101c484807870384d401c20350055502100001e000000ff00485a43574e38330a2020202020000000fc0044454c4c205332373231484746000000fd0030901eaa22000a202020202020017302032bf14a3f101f0413121103020123097f078301000065030c0020006d1a000002013090e60000000000c484807870384d401c20350055502100001e866f80a0703840403020350055502100001a662156aa51001e30468f330055502100001e0000000000000000000000000000000000000000000000000000000000006f";
              };
              config = {
                "eDP-1" = {
                  enable = true;
                  primary = true;
                  position = "0x0";
                  mode = "1920x1080";
                  rate = "60.01";
                };
                "HDMI-1" = {
                  enable = true;
                  primary = false;
                  position = "1920x0";
                  mode = "1920x1080";
                  rate = "120.00";
                };
              };
            };
          };
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
          # ACPI reports the lid closed while eDP-1 is still the powered
          # primary panel. Without --ignore-lid, autorandr drops that panel
          # whenever HDMI is attached and the two outputs stay cloned.
          displayManager.setupCommands = ''
            ${pkgs.autorandr}/bin/autorandr --change --default laptop --ignore-lid || true
          '';
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

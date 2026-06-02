{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/services.nix
  flake.nixosModules.services =
    { lib, pkgs, ... }:
    {
      services = {
        # hledger-web.enable = true;
        libinput.enable = true;
        thermald.enable = true;
        gvfs.enable = true;
        udisks2.enable = true;
        devmon.enable = true;

        # Enable periodic TRIM on the SSD. The NVMe drive maintains better
        # long-term write performance when the firmware can regularly discard
        # unused blocks instead of running out of clean flash for new writes.
        fstrim.enable = true;

        # Limit persistent journal size using structured attr set converted to
        # the key=value lines that extraConfig expects (they get appended under
        # the [Journal] section in the generated journald.conf).
        # Without limits, logs from the many GUI/Electron apps (Brave, Signal,
        # Zoom, Bitwarden, etc.) plus system services can grow to many GB over
        # time. This wastes disk space (bad for SSD longevity and low-space
        # situations) and adds background I/O. Conservative limits for a
        # laptop/desktop that keeps logs for about a month.
        journald.extraConfig = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "${name}=${value}") {
            SystemMaxUse = "500M";
            SystemKeepFree = "1G";
            MaxFileSec = "1month";
          }
        );

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
    };
}

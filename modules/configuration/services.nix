{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/services.nix
  flake.nixosModules.services =
    { lib, pkgs, ... }:
    let
      # Structured definition of journal limits. This is the "newer" way to
      # express the values (plain Nix attrset). We currently feed it into
      # extraConfig because services.journald.settings does not exist in the
      # nixpkgs revision this flake is locked to.
      #
      # Once a nixpkgs update brings in the native support, this can become:
      #
      #   services.journald.settings = {
      #     Journal = journalLimits;
      #   };
      #
      # (The module will then generate the [Journal] section automatically.)
      journalLimits = {
        SystemMaxUse = "500M";
        SystemKeepFree = "1G";
        MaxFileSec = "1month";
      };
    in
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

        # Limit persistent journal size. The values live in the structured
        # journalLimits attrset above. We convert it to the key=value format
        # that extraConfig expects (it gets appended under [Journal]).
        #
        # This stops logs from the many GUI/Electron apps (Brave, Signal,
        # Zoom, Bitwarden, etc.) from growing without bound, which would
        # waste disk space and add unnecessary background I/O.
        journald.extraConfig = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: "${name}=${value}") journalLimits
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

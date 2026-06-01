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
        gvfs.enable = true;
        udisks2.enable = true;
        devmon.enable = true;

        # Enable periodic TRIM on the SSD. The NVMe drive maintains better
        # long-term write performance when the firmware can regularly discard
        # unused blocks instead of running out of clean flash for new writes.
        fstrim.enable = true;

        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          jack.enable = true;
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

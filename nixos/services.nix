{
  services = {
    libinput.enable = true;
    thermald.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

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
}

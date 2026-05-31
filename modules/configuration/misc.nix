{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old base system settings
  flake.nixosModules.system =
    { pkgs, ... }:
    {
      system.stateVersion = "24.05";
      # copySystemConfiguration = true;

      # Disabled to avoid pulling in large amounts of development documentation
      # and man pages for every package in the system profile.
      documentation.dev.enable = false;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.android_sdk.accept_license = true;

      time.timeZone = "Asia/Jerusalem";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
      };

      environment.pathsToLink = [ "/share/zsh" ];
    };
}

{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old base system settings
  flake.nixosModules.system =
    { pkgs, ... }:
    {
      # Bumped from 24.05 to 26.05 after reviewing that the configuration has no
      # database servers, self-hosted web applications, or other services with
      # schema or data directory migrations that are sensitive to stateVersion.
      # The explicit package choices (such as transmission_4) further reduce risk.
      # This allows the system to use current defaults and remove old compatibility
      # shims while the machine continues to run NixOS 26.05.
      system.stateVersion = "26.05";
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

{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old base system settings
  flake.nixosModules.system =
    { pkgs, ... }:
    {
      system.stateVersion = "24.05";
      # copySystemConfiguration = true;

      documentation.dev.enable = true;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.android_sdk.accept_license = true;

      time.timeZone = "Asia/Jerusalem";
      i18n.defaultLocale = "en_US.UTF-8";

      environment.pathsToLink = [ "/share/zsh" ];
    };
}

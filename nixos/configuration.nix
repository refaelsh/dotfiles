{ inputs, ... }:
{
  system = {
    stateVersion = "24.05";
    # copySystemConfiguration = true;
  };

  documentation.dev.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    # Don't forget to add the below to your system configuration to get completion for system packages (e.g. systemd).
    pathsToLink = [ "/share/zsh" ];
  };

  imports = [
    ./systemd-services.nix
  ];
}

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
    ./hardware-configuration.nix
    ./environment-variables.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./power-management.nix
    ./scriptology.nix
    ./security.nix
    ./systemd-services.nix
    ./users.nix
    ./etc-dotfiles.nix
  ];
}

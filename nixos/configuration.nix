{ inputs, ... }:
{
  system = {
    stateVersion = "24.05";
    # copySystemConfiguration = true;
  };

  documentation.dev.enable = true;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    # Don't forget to add the below to your system configuration to get completion for system packages (e.g. systemd).
    pathsToLink = [ "/share/zsh" ];
  };

  nixpkgs.config.android_sdk.accept_license = true;

  imports = [
    ./hardware-configuration.nix
    ./default-applications.nix
    ./environment-variables.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./power-management.nix
    ./programs.nix
    ./scriptology.nix
    ./security.nix
    ./systemd-services.nix
    ./users.nix
    ./etc-dotfiles.nix
  ];
}

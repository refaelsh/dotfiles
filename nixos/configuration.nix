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
    ./boot-loader.nix
    ./default-applications.nix
    ./enviornment-system-package.nix
    ./environment-variables.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./power-management.nix
    ./programs.nix
    ./scriptology.nix
    ./security.nix
    ./services.nix
    ./systemd-services.nix
    ./users.nix
  ];

  environment.etc."brave/policies/managed/policies.json".text = ''
    {
      "BraveRewardsDisabled": true,
      "TorDisabled": true,
      "BraveWalletDisabled": true,
      "PasswordManagerEnabled": false,
      "AutofillAddressEnabled": false,
      "AutofillCreditCardEnabled": false,
      "MetricsReportingEnabled": false,
      "TranslateEnabled": false,
      "SpellcheckEnabled": false,
      "BraveAdsDisabled": true,
      "BackgroundModeEnabled": false,
      "BraveVPNDisabled": true,
      "BraveAIChatEnabled": false,
    }
  '';
}

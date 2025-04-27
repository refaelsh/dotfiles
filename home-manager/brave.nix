{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--disable-background-networking"
      "--disable-default-apps"
      "--disable-features=TranslateUI"
    ];
  };

  xdg.configFile."BraveSoftware/Brave-Browser/policies/managed/policies.json".text = ''
    {
      "BraveRewardsDisabled": true,
      "TorDisabled": true,
      "IPFSDisabled": true,
      "BraveWalletDisabled": true,
      "PasswordManagerEnabled": false,
      "AutofillEnabled": false,
      "MetricsReportingEnabled": false,
      "TranslateEnabled": false,
      "SpellcheckEnabled": false,
      "NewTabPageContentEnabled": false,
      "BraveAdsDisabled": true,
      "BackgroundModeEnabled": false,
      "BraveVPNDisabled": true,
    }
  '';
}

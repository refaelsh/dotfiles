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
      "SyncDisabled": true,
      "PasswordManagerEnabled": false,
      "AutofillEnabled": false,
      "SafeBrowsingEnabled": false,
      "MetricsReportingEnabled": false,
      "TranslateEnabled": false,
      "SpellcheckEnabled": false,
      "ExtensionsToolbarMenuEnabled": false,
      "HardwareAccelerationMode": 0
    }
  '';
}

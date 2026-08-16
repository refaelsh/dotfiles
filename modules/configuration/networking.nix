{ inputs, ... }:
{
  flake.nixosModules.networking =
    { ... }:
    {
      networking = {
        hostName = "nixos";
        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
      };

      # This laptop lives in Israel (time.timeZone = Asia/Jerusalem).
      # Without an explicit domain, cfg80211 stayed at country 99 on the
      # QCA9377 and the stack advertised DE, which marks channels 12–13
      # as no-IR and applies the wrong 5 GHz DFS/power set.
      boot.extraModprobeConfig = ''
        options cfg80211 ieee80211_regdom=IL
      '';
    };
}

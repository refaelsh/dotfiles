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

      # Initial cfg80211 domain for this laptop (Asia/Jerusalem). The
      # QCA9377 is an Atheros world SKU and still copies the country
      # element from the associated AP after this, so the phy can leave
      # IL. Stopping that means a kernel change, which we are not doing.
      boot.extraModprobeConfig = ''
        options cfg80211 ieee80211_regdom=IL
      '';
    };
}

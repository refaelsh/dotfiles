{ inputs, ... }:
{
  flake.nixosModules.networking =
    { lib, pkgs, ... }:
    {
      networking = {
        hostName = "nixos";
        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
      };

      # This laptop is in Israel. The QCA9377 is an Atheros world SKU: it
      # copies the country element from the associated AP. Nearby APs send
      # DE, the phy stays on world domain 99, channels 12–13 stay no-IR,
      # and the 5 GHz DFS/power set is the foreign one.
      #
      # `ieee80211_regdom=IL` does not fix that. It is a core hint, and ath
      # ignores core hints on a custom regulatory domain. A later
      # `iw reg set IL` is also a no-op if the global domain is already IL.
      # Leave the global domain at the world default so the oneshot below
      # is a real user hint. The patch stops the AP element from replacing
      # it, and ATH_REG_DYNAMIC_USER_REG_HINTS is what makes ath apply that
      # hint to the phy (including clearing no-IR on channels 12–13).
      boot.kernelPatches = [
        {
          name = "ath-ignore-country-ie";
          patch = pkgs.writeText "ath-ignore-country-ie.patch" ''
            --- a/drivers/net/wireless/ath/regd.c	2026-09-21 23:00:51.839392003 +0300
            +++ b/drivers/net/wireless/ath/regd.c	2026-09-21 23:00:51.839834868 +0300
            @@ -650,6 +650,14 @@
             		 */
             		regd = ath_world_regdomain(reg);
             		wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_FOLLOW_POWER;
            +		/*
            +		 * A world SKU copies the country element from the AP. On this
            +		 * QCA9377 that element is a foreign domain, so channels 12-13 stay
            +		 * no-IR and the 5 GHz DFS/power limits are wrong for IL. Ignore the
            +		 * element. Userspace sets IL with `iw reg set`, which ath applies
            +		 * only when ATH_REG_DYNAMIC_USER_REG_HINTS is enabled.
            +		 */
            +		wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_IGNORE;
             	} else {
             		/*
             		 * This gets applied in the case of the absence of CRDA,
          '';
          structuredExtraConfig = {
            ATH_REG_DYNAMIC_USER_REG_HINTS = lib.kernel.yes;
          };
        }
      ];

      # User hint, not a module parameter. See the comment above for why
      # the hint has to come from userspace after the world default.
      # Retries cover the window before cfg80211 is loaded. The udev rule
      # runs the unit again if the phy is created after the oneshot.
      systemd.services.wifi-regdom-il = {
        description = "Pin the Wi-Fi regulatory domain to IL";
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-modules-load.service" ];
        path = [
          pkgs.iw
          pkgs.coreutils
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "wifi-regdom-il" ''
            i=0
            while [ "$i" -lt 20 ]; do
              if iw reg set IL; then
                exit 0
              fi
              i=$((i + 1))
              sleep 0.5
            done
            echo "iw reg set IL failed" >&2
            exit 1
          '';
        };
      };

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="ieee80211", TAG+="systemd", ENV{SYSTEMD_WANTS}="wifi-regdom-il.service"
      '';
    };
}

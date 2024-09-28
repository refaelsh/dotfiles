{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.nixmobar;
in
{
  options.services.nixmobar = {
    # Option to enable or disable the nixmobar service
    enable = mkEnableOption "nixmobar service";

    # A simple integer option for the refresh interval in seconds
    refreshInterval = mkOption {
      type = types.int;
      default = 300; # Default refresh interval of 5 minutes
      description = "The interval in seconds at which nixmobar refreshes its data.";
    };

    # Option to append extra configuration to the nixmobar config
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines to be added to the nixmobar configuration.";
    };
  };

  config = mkIf cfg.enable {
    # Here you would typically set up the service, but for this example, we're just setting up the configuration.
    environment.etc."nixmobar/bla".text = ''
      # Basic configuration for nixmobar
      refresh_interval = ${toString cfg.refreshInterval}

      # Include extra configuration provided by the user
      ${cfg.extraConfig}
    '';
  };
}

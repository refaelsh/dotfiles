{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nixmobar;
in
{
  # Define the options for the module
  options.programs.nixmobar = {
    enable = mkEnableOption "nixmobar, a minimal status bar";

    updateInterval = mkOption {
      type = types.int;
      default = 30;
      description = "The interval in seconds at which the bar updates.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines to add to nixmobar's config.";
    };
  };

  # Actual configuration for home-manager
  config = mkIf cfg.enable {
    home.packages = [ pkgs.nixmobar ];

    xdg.configFile."nixmobar/bla" = {
      text = ''
        # Base configuration for nixmobar
        [general]
        update-interval = ${toString cfg.updateInterval}

        # Here you might include default settings or templates for nixmobar

        # Extra configuration provided by the user
        ${cfg.extraConfig}
      '';
    };
  };
}

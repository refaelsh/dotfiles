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

    settings = mkOption {
      type = types.attrs;
      default = {
        bla = "h";
        bla2 = "\"h2\"";
        bla3 = "42";
      };
      description = ''
        An attribute set that will be converted to Xmobar's configuration format.
        Adjust the conversion in the module if Xmobar uses a different config format.
      '';
    };

    commands = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines to add to nixmobar's config.";
    };
  };

  # Actual configuration for home-manager
  config = mkIf cfg.enable {
    home.packages = [ pkgs.xmobar ];

    # xdg.configFile."xmobar/.xmobarrc_bla" = {
    #   text = builtins.concatStringsSep "\n" (
    #     [ "Config {" ]
    #     ++ builtins.attrValues (builtins.mapAttrs (name: value: "${name} = ${value}") cfg.settings)
    #   );
    # };

    xdg.configFile."xmobar/.xmobarrc_bla" = {
      text = builtins.concatStringsSep "\n" (
        [
          "Config {"
        ]
        ++ builtins.attrValues (builtins.mapAttrs (name: value: "  ${name} = ${value},") cfg.settings)
        ++ [ "  commands = [" ]
        ++ [ cfg.commands ]
        ++ [ "  ]" ]
        ++ [
          "}"
        ]
      );
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.programs.nixmobar = {
    enable = mkEnableOption "Enable nixmobar customization for Xmobar";

    font = mkOption {
      type = types.str;
      default = "xft:Monospace:size=10";
      description = "The font to use in Xmobar.";
    };

    bgColor = mkOption {
      type = types.str;
      default = "#000000";
      description = "Background color of the bar.";
    };

    fgColor = mkOption {
      type = types.str;
      default = "#ffffff";
      description = "Foreground (text) color of the bar.";
    };

    template = mkOption {
      type = types.str;
      default = "%date% | %battery% | %cpu% | %memory%";
      description = "The template for the bar content.";
    };

    # Here you can add more options like position, commands for plugins, etc.
    commands = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
        {
          date = "date '+%Y-%m-%d %H:%M'";
          battery = "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}'";
        }
      '';
      description = "Commands to run for updating bar segments.";
    };

    # Additional configurations can be added here
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.xmobar ];

    xdg.configFile."xmobar/bla".text = ''
      Config {
        font = "${cfg.font}",
        bgColor = "${cfg.bgColor}",
        fgColor = "${cfg.fgColor}",
        ${toXmobarConfig cfg.commands}
        -- Add more config options here based on what's defined in the module
      }
      ${cfg.template}
    '';
  };
}

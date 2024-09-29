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
    enable = mkEnableOption (mdDoc "Xmobar, a minimalistic status bar");

    font = mkOption {
      type = types.str;
      default = "Fira Code 13";
      description = mdDoc "Main font for Xmobar.";
    };

    additionalFonts = mkOption {
      type = types.listOf types.str;
      default = [ "Fira Code 22" ];
      description = mdDoc "Additional fonts for use in Xmobar.";
    };

    bgColor = mkOption {
      type = types.str;
      default = "#282a36";
      description = mdDoc "Background color of Xmobar.";
    };

    fgColor = mkOption {
      type = types.str;
      default = "#f8f8f2";
      description = mdDoc "Foreground (text) color of Xmobar.";
    };

    textOffset = mkOption {
      type = types.int;
      default = 2;
      description = mdDoc "Offset of the text from the edge.";
    };

    verbose = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Enable verbose mode for Xmobar.";
    };

    allDesktops = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Show Xmobar on all desktops.";
    };

    lowerOnStart = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Whether Xmobar should be lowered on start.";
    };

    overrideRedirect = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "If true, Xmobar will bypass window manager redirection.";
    };

    position = mkOption {
      type = types.str;
      default = "BottomH 26";
      description = mdDoc "Position of Xmobar on the screen.";
    };

    alpha = mkOption {
      type = types.int;
      default = 200;
      description = mdDoc "Transparency level of Xmobar (0-255).";
    };

    commands = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = mdDoc "Name of the command or plugin.";
            };
            settings = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = mdDoc "Settings or arguments for the command.";
            };
          };
        }
      );
      default = [
        # Here you would list your commands like XMonadLog, DiskU, etc., with their respective settings
      ];
      description = mdDoc "List of commands to run in Xmobar.";
    };

    alignSep = mkOption {
      type = types.str;
      default = "}{";
      description = mdDoc "Separators for alignment left and right.";
    };

    template = mkOption {
      type = types.str;
      default = "<hspace=8/>%XMonadLog% }{ %load%|%disku%|%diskio%|<fc=#bd93f9><fn=1></fn></fc>%wifi_signal%|%dynnetwork%|<fc=#bd93f9><fn=1>󰈐</fn></fc>%cat0%|%multicoretemp%|%cpufreq%|%multicpu%|<fc=#bd93f9><fn=1></fn></fc>%kbd%|%memory% %swap%|%battery%|%alsa:default:Master%|<fc=#bd93f9><fn=1></fn></fc>%kernel_version%|%date%|%_XMONAD_TRAYPAD%";
      description = mdDoc "Template string for Xmobar layout.";
    };

    # Additional commands could be defined here using mkCommand helper function
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

    # xdg.configFile."xmobar/.xmobarrc_bla" = {
    #   text = builtins.concatStringsSep "\n" (
    #     [
    #       "Config {"
    #     ]
    #     ++ builtins.attrValues (builtins.mapAttrs (name: value: "  ${name} = ${value},") cfg.settings)
    #     ++ [ "  commands = [" ]
    #     ++ [ cfg.commands ]
    #     ++ [ "  ]" ]
    #     ++ [
    #       "}"
    #     ]
    #   );
    # };
  };
}

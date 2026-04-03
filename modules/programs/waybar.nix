{ config, lib, pkgs, ... }:
with lib;
{
  # This makes the module reusable and clean (standard NixOS module pattern)
  options.programs.waybar = {
    enable = mkEnableOption "Waybar status bar for Hyprland / Wayland";
  };

  config = mkIf config.programs.waybar.enable {
    programs.waybar = {
      enable = true;

      # Automatically start Waybar via systemd user service
      systemd.enable = true;

      # ── STYLE ─────────────────────────────────────────────────────────────
      # Fixed: style must be a plain string (or path), NOT an attrset { css = ... }
      style = ''
        * {
          font-family: "Fira Code", "FiraCode Nerd Font";
          font-size: 13px;
          font-weight: normal;
          border-radius: 0;
        }

        window#waybar {
          background-color: rgba(0, 0, 0, 0.85);
          color: #ffffff;
          border-bottom: 2px solid rgba(255, 255, 255, 0.1);
        }

        /* Add the rest of your custom CSS here */
        /* (copy-paste everything that was inside your old css = '' ... '' block) */
      '';

      # ── SETTINGS ──────────────────────────────────────────────────────────
      # Example configuration (customize to your liking)
      settings = [{
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        # Modules
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];

        # Clock
        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%Y-%m-%d | %A}";
          calendar = {
            mode = "year";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        # Audio
        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "󰝟";
          on-click = "pavucontrol";
        };

        # Network
        network = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          tooltip-format = "{ipaddr}";
        };

        # Battery
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        # Tray
        tray = {
          spacing = 8;
        };
      }];
    };
  };
}

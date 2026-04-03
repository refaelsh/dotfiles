# modules/programs/waybar.nix
{ config, lib, pkgs, wrappers, ... }:

let
  cfg = config.programs.waybar;
in
{
  # Clean, reusable options (you can override these from your main config if you want)
  options.programs.waybar = with lib; {
    enable = mkEnableOption "Waybar status bar (using Lassulus/wrappers)";
  };

  config = mkIf cfg.enable {
    # Use the exact existing module from https://github.com/Lassulus/wrappers
    # The only change needed was switching from the invalid `style = { css = ... }`
    # to the correct `"style.css".content = ...` that the wrapper expects.
    environment.systemPackages = [
      (wrappers.wrapperModules.waybar.apply {
        inherit pkgs;

        # ── SETTINGS (JSON config) ─────────────────────────────────────
        settings = {
          layer = "top";
          position = "top";
          height = 32;
          spacing = 4;

          modules-left = [ "hyprland/workspaces" "hyprland/window" ];
          modules-center = [ "clock" ];
          modules-right = [ "pulseaudio" "network" "battery" "tray" ];

          clock = {
            format = "{:%H:%M}";
            tooltip-format = "{:%Y-%m-%d | %A}";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "󰝟";
            on-click = "pavucontrol";
          };

          network = {
            format-wifi = " {essid}";
            format-ethernet = "󰈀";
            format-disconnected = "󰤭";
          };

          battery = {
            format = "{capacity}% {icon}";
            format-icons = [ "" "" "" "" "" ];
          };

          tray = {
            spacing = 8;
          };
        };

        # ── STYLE (this is what was causing your error) ───────────────
        # Correct key for the Lassulus wrapper is literally "style.css".content
        "style.css".content = ''
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

          /* Add your additional custom CSS rules below this line */
        '';
      }).wrapper
    ];
  };
}

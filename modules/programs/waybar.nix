# modules/programs/waybar.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.programs.waybar;
in
{
  # Options so you can enable/disable it cleanly from your main config
  options.programs.waybar = {
    enable = lib.mkEnableOption "Waybar status bar (using Lassulus/wrappers)";
  };

  config = lib.mkIf cfg.enable {
    # Use the exact existing module from https://github.com/Lassulus/wrappers
    environment.systemPackages = [
      (inputs.wrappers.wrapperModules.waybar.apply {
        inherit pkgs;

        # ── SETTINGS (JSON config) ─────────────────────────────────────
        settings = {
          layer = "top";
          position = "top";
          height = 32;
          spacing = 4;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "pulseaudio"
            "network"
            "battery"
            "tray"
          ];

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
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };

          tray = {
            spacing = 8;
          };
        };

        # ── STYLE ─────────────────────────────────────────────────────
        # This is the exact key the Lassulus wrapper expects
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

          /* Add the rest of your custom CSS rules here */
        '';
      }).wrapper
    ];
  };
}

{ inputs, ... }:
{
  # Beautiful Waybar feature using official Lassulus/wrappers module
  flake.nixosModules.waybar =
    { pkgs, ... }:
    let
      waybar-wrapped =
        (inputs.wrappers.wrapperModules.waybar.apply {
          inherit pkgs;

          settings = {
            mainBar = {
              layer = "top";
              position = "top";
              height = 32;
              margin = "4 4 0 4";
              spacing = 4;

              modules-left = [
                "custom/launcher"
                "hyprland/workspaces"
                "custom/playerctl"
              ];
              modules-center = [ "clock" ];
              modules-right = [
                "pulseaudio"
                "network"
                "cpu"
                "memory"
                "temperature"
                "battery"
                "tray"
              ];

              "hyprland/workspaces" = {
                format = "{icon}";
                format-icons = {
                  active = "";
                  default = "";
                };
              };

              clock = {
                format = "{:%H:%M}";
                tooltip-format = "{:%A, %d %B %Y}";
                calendar = {
                  mode = "year";
                  mode-mon-col = 3;
                  weeks-pos = "right";
                };
              };

              cpu = {
                format = "{usage}% ";
                tooltip = false;
              };

              memory = {
                format = "{}% ";
              };

              temperature = {
                format = "{temperatureC}°C {icon}";
                format-icons = [
                  ""
                  ""
                  ""
                ];
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
                states = {
                  warning = 30;
                  critical = 15;
                };
              };

              network = {
                format-wifi = "{essid} ";
                format-ethernet = "";
                format-disconnected = "⚠ Disconnected";
              };

              pulseaudio = {
                format = "{volume}% {icon}";
                format-icons = {
                  default = [
                    ""
                    ""
                    ""
                  ];
                };
              };

              tray = {
                spacing = 10;
              };

              "custom/launcher" = {
                format = "";
                tooltip = false;
                on-click = "pkill -x wofi || wofi --show drun";
              };

              "custom/playerctl" = {
                format = "{icon} {}";
                exec = "playerctl -a metadata --format '{{title}} - {{artist}}'";
                return-type = "json";
                on-click = "playerctl play-pause";
                on-click-right = "playerctl next";
              };
            };
          };

          style.css = ''
            * {
              font-family: "Fira Code", "FiraCode Nerd Font";
              font-size: 13px;
              font-weight: 500;
            }

            window#waybar {
              background: rgba(40, 42, 54, 0.95);
              color: #F8F8F2;
              border-radius: 10px;
              border: 2px solid #BD93F9;
            }

            #workspaces button {
              padding: 0 8px;
              color: #F8F8F2;
            }

            #workspaces button.active {
              background: #BD93F9;
              color: #282A36;
            }

            #clock, #cpu, #memory, #temperature, #battery, #network, #pulseaudio, #tray {
              padding: 0 12px;
            }

            #battery.warning {
              color: #FFB86C;
            }

            #battery.critical {
              color: #FF5555;
            }
          '';
        }).wrapper;
    in
    {
      environment.systemPackages = [ waybar-wrapped ];
    };
}

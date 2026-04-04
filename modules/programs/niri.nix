{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      # ── Only the "important hotkeys" from niri's default-config.kdl ──
      importantBinds = {
        # Hotkey overlay
        "Mod+Shift+Slash" = {
          show-hotkey-overlay = null;
        };

        # Core important actions
        "Mod+Q" = {
          repeat = false;
          close-window = null;
        };
        "Mod+O" = {
          repeat = false;
          toggle-overview = null;
        };

        # Basic navigation (arrows + hjkl)
        "Mod+Left" = {
          focus-column-left = null;
        };
        "Mod+Right" = {
          focus-column-right = null;
        };
        "Mod+Up" = {
          focus-window-up = null;
        };
        "Mod+Down" = {
          focus-window-down = null;
        };
        "Mod+H" = {
          focus-column-left = null;
        };
        "Mod+L" = {
          focus-column-right = null;
        };
        "Mod+J" = {
          focus-window-down = null;
        };
        "Mod+K" = {
          focus-window-up = null;
        };

        "Mod+Ctrl+Left" = {
          move-column-left = null;
        };
        "Mod+Ctrl+Right" = {
          move-column-right = null;
        };
        "Mod+Ctrl+Up" = {
          move-window-up = null;
        };
        "Mod+Ctrl+Down" = {
          move-window-down = null;
        };
        "Mod+Ctrl+H" = {
          move-column-left = null;
        };
        "Mod+Ctrl+L" = {
          move-column-right = null;
        };
        "Mod+Ctrl+J" = {
          move-window-down = null;
        };
        "Mod+Ctrl+K" = {
          move-window-up = null;
        };

        # WORKSPACE / DESKTOP SWITCHING & MOVING
        "Mod+Page_Down" = {
          focus-workspace-down = null;
        };
        "Mod+Page_Up" = {
          focus-workspace-up = null;
        };
        "Mod+U" = {
          focus-workspace-down = null;
        };
        "Mod+I" = {
          focus-workspace-up = null;
        };
        "Mod+Ctrl+Page_Down" = {
          move-column-to-workspace-down = null;
        };
        "Mod+Ctrl+Page_Up" = {
          move-column-to-workspace-up = null;
        };
        "Mod+Ctrl+U" = {
          move-column-to-workspace-down = null;
        };
        "Mod+Ctrl+I" = {
          move-column-to-workspace-up = null;
        };

        # Mouse wheel (fixed syntax for the wrapper)
        "Mod+WheelScrollDown" = {
          focus-workspace-down = null;
          _attrs = {
            cooldown-ms = 150;
          };
        };
        "Mod+WheelScrollUp" = {
          focus-workspace-up = null;
          _attrs = {
            cooldown-ms = 150;
          };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          move-column-to-workspace-down = null;
          _attrs = {
            cooldown-ms = 150;
          };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          move-column-to-workspace-up = null;
          _attrs = {
            cooldown-ms = 150;
          };
        };

        # Launcher
        "Mod+D" = {
          spawn = [ "fuzzel" ];
        };
      };

      customBinds = {
        "Mod+Return" = {
          spawn = [ "${pkgs.kitty}/bin/kitty" ];
        };
      };

      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;
          settings = {
            spawn-at-startup = [ "waybar" ];
            binds = importantBinds // customBinds;
          };
        }).wrapper;
    in
    {
      programs.niri = {
        enable = true;
        package = niri-wrapped;
      };
    };
}

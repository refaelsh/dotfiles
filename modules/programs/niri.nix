{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    let
      # ── Only the "important hotkeys" from niri's default-config.kdl ──
      importantBinds = {
        # Hotkey overlay
        "Mod+Shift+Slash" = {
          show-hotkey-overlay = null;
        };

        # Core important actions
        "Mod+Q" = {
          close-window = null;
          _attrs = {
            repeat = false;
          };
        };
        "Mod+O" = {
          toggle-overview = null;
          _attrs = {
            repeat = false;
          };
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

        # WORKSPACE / DESKTOP SWITCHING & MOVING (relative)
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

        # Move individual WINDOW to different workspace/desktop (relative)
        "Mod+Ctrl+Shift+Page_Down" = {
          move-window-to-workspace-down = null;
        };
        "Mod+Ctrl+Shift+Page_Up" = {
          move-window-to-workspace-up = null;
        };
        "Mod+Ctrl+Shift+U" = {
          move-window-to-workspace-down = null;
        };
        "Mod+Ctrl+Shift+I" = {
          move-window-to-workspace-up = null;
        };

        # Mouse wheel
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

      # ── Numeric workspace keys (Mod+1 … Mod+9) ──
      numericBinds = lib.mergeAttrsList (
        map (
          n:
          let
            s = toString n;
          in
          {
            "Mod+${s}" = {
              focus-workspace = n;
            };
            "Mod+Ctrl+${s}" = {
              move-column-to-workspace = n;
            };
            "Mod+Ctrl+Shift+${s}" = {
              move-window-to-workspace = n;
            };
          }
        ) (lib.range 1 9)
      );

      customBinds = {
        "Mod+Return" = {
          spawn = [ "${pkgs.kitty}/bin/kitty" ];
          _attrs = {
            hotkey-overlay-title = "Open terminal: kitty";
          }; # ← now shows in overlay
        };

        # Restart niri
        "Mod+Shift+R" = {
          spawn = [
            "niri"
            "msg"
            "action"
            "restart"
          ];
          _attrs = {
            hotkey-overlay-title = "Restart niri";
          }; # ← now shows in overlay
        };
      };

      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;
          settings = {
            spawn-at-startup = [ "waybar" ];
            binds = importantBinds // numericBinds // customBinds;
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

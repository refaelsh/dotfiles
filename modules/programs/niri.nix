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
          _attrs = {
            hotkey-overlay-title = "Show important hotkeys";
          };
        };

        # Core important actions
        "Mod+Q" = {
          close-window = null;
          _attrs = {
            repeat = false;
            hotkey-overlay-title = "Close window";
          };
        };
        "Mod+O" = {
          toggle-overview = null;
          _attrs = {
            repeat = false;
            hotkey-overlay-title = "Toggle overview";
          };
        };

        # Basic navigation (arrows + hjkl)
        "Mod+Left" = {
          focus-column-left = null;
          _attrs = {
            hotkey-overlay-title = "Focus column left";
          };
        };
        "Mod+Right" = {
          focus-column-right = null;
          _attrs = {
            hotkey-overlay-title = "Focus column right";
          };
        };
        "Mod+Up" = {
          focus-window-up = null;
          _attrs = {
            hotkey-overlay-title = "Focus window up";
          };
        };
        "Mod+Down" = {
          focus-window-down = null;
          _attrs = {
            hotkey-overlay-title = "Focus window down";
          };
        };
        "Mod+H" = {
          focus-column-left = null;
          _attrs = {
            hotkey-overlay-title = "Focus column left (H)";
          };
        };
        "Mod+L" = {
          focus-column-right = null;
          _attrs = {
            hotkey-overlay-title = "Focus column right (L)";
          };
        };
        "Mod+J" = {
          focus-window-down = null;
          _attrs = {
            hotkey-overlay-title = "Focus window down (J)";
          };
        };
        "Mod+K" = {
          focus-window-up = null;
          _attrs = {
            hotkey-overlay-title = "Focus window up (K)";
          };
        };

        "Mod+Ctrl+Left" = {
          move-column-left = null;
          _attrs = {
            hotkey-overlay-title = "Move column left";
          };
        };
        "Mod+Ctrl+Right" = {
          move-column-right = null;
          _attrs = {
            hotkey-overlay-title = "Move column right";
          };
        };
        "Mod+Ctrl+Up" = {
          move-window-up = null;
          _attrs = {
            hotkey-overlay-title = "Move window up";
          };
        };
        "Mod+Ctrl+Down" = {
          move-window-down = null;
          _attrs = {
            hotkey-overlay-title = "Move window down";
          };
        };
        "Mod+Ctrl+H" = {
          move-column-left = null;
          _attrs = {
            hotkey-overlay-title = "Move column left (H)";
          };
        };
        "Mod+Ctrl+L" = {
          move-column-right = null;
          _attrs = {
            hotkey-overlay-title = "Move column right (L)";
          };
        };
        "Mod+Ctrl+J" = {
          move-window-down = null;
          _attrs = {
            hotkey-overlay-title = "Move window down (J)";
          };
        };
        "Mod+Ctrl+K" = {
          move-window-up = null;
          _attrs = {
            hotkey-overlay-title = "Move window up (K)";
          };
        };

        # WORKSPACE / DESKTOP SWITCHING & MOVING (relative)
        "Mod+Page_Down" = {
          focus-workspace-down = null;
          _attrs = {
            hotkey-overlay-title = "Focus workspace down";
          };
        };
        "Mod+Page_Up" = {
          focus-workspace-up = null;
          _attrs = {
            hotkey-overlay-title = "Focus workspace up";
          };
        };
        "Mod+U" = {
          focus-workspace-down = null;
          _attrs = {
            hotkey-overlay-title = "Focus workspace down (U)";
          };
        };
        "Mod+I" = {
          focus-workspace-up = null;
          _attrs = {
            hotkey-overlay-title = "Focus workspace up (I)";
          };
        };
        "Mod+Ctrl+Page_Down" = {
          move-column-to-workspace-down = null;
          _attrs = {
            hotkey-overlay-title = "Move column to workspace down";
          };
        };
        "Mod+Ctrl+Page_Up" = {
          move-column-to-workspace-up = null;
          _attrs = {
            hotkey-overlay-title = "Move column to workspace up";
          };
        };
        "Mod+Ctrl+U" = {
          move-column-to-workspace-down = null;
          _attrs = {
            hotkey-overlay-title = "Move column to workspace down (U)";
          };
        };
        "Mod+Ctrl+I" = {
          move-column-to-workspace-up = null;
          _attrs = {
            hotkey-overlay-title = "Move column to workspace up (I)";
          };
        };

        # Move individual WINDOW to different workspace/desktop (relative)
        "Mod+Ctrl+Shift+Page_Down" = {
          move-window-to-workspace-down = null;
          _attrs = {
            hotkey-overlay-title = "Move window to workspace down";
          };
        };
        "Mod+Ctrl+Shift+Page_Up" = {
          move-window-to-workspace-up = null;
          _attrs = {
            hotkey-overlay-title = "Move window to workspace up";
          };
        };
        "Mod+Ctrl+Shift+U" = {
          move-window-to-workspace-down = null;
          _attrs = {
            hotkey-overlay-title = "Move window to workspace down (U)";
          };
        };
        "Mod+Ctrl+Shift+I" = {
          move-window-to-workspace-up = null;
          _attrs = {
            hotkey-overlay-title = "Move window to workspace up (I)";
          };
        };

        # Mouse wheel
        "Mod+WheelScrollDown" = {
          focus-workspace-down = null;
          _attrs = {
            cooldown-ms = 150;
            hotkey-overlay-title = "Focus workspace down (wheel)";
          };
        };
        "Mod+WheelScrollUp" = {
          focus-workspace-up = null;
          _attrs = {
            cooldown-ms = 150;
            hotkey-overlay-title = "Focus workspace up (wheel)";
          };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          move-column-to-workspace-down = null;
          _attrs = {
            cooldown-ms = 150;
            hotkey-overlay-title = "Move column to workspace down (wheel)";
          };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          move-column-to-workspace-up = null;
          _attrs = {
            cooldown-ms = 150;
            hotkey-overlay-title = "Move column to workspace up (wheel)";
          };
        };

        # Launcher
        "Mod+D" = {
          spawn = [ "fuzzel" ];
          _attrs = {
            hotkey-overlay-title = "Run application: fuzzel";
          };
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
              _attrs = {
                hotkey-overlay-title = "Switch to workspace ${s}";
              };
            };
            "Mod+Ctrl+${s}" = {
              move-column-to-workspace = n;
              _attrs = {
                hotkey-overlay-title = "Move column to workspace ${s}";
              };
            };
            "Mod+Ctrl+Shift+${s}" = {
              move-window-to-workspace = n;
              _attrs = {
                hotkey-overlay-title = "Move window to workspace ${s}";
              };
            };
          }
        ) (lib.range 1 9)
      );

      customBinds = {
        "Mod+Return" = {
          spawn = [ "${pkgs.kitty}/bin/kitty" ];
          _attrs = {
            hotkey-overlay-title = "Open terminal: kitty";
          };
        };

        # Restart niri
        "Mod+Shift+R" = {
          spawn-sh = "niri msg action restart";
          _attrs = {
            repeat = false;
            hotkey-overlay-title = "Restart niri";
          };
        };

        # NEW: Window maximize (minimal version — no title to guarantee it builds)
        "Mod+F" = {
          toggle-window-maximized = null;
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

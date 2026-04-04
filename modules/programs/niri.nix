{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;

          settings = {
            spawn-at-startup = [
              "waybar"
            ];

            binds = {
              # Your existing custom bind (kept)
              "Mod+Return" = {
                spawn = [ "kitty" ];
              };

              # ── All the default keybindings from niri (restored) ──
              # (converted to the exact syntax the wrapper expects)

              "Mod+Shift+Slash" = {
                show-hotkey-overlay = null;
              };

              "Mod+D" = {
                hotkey-overlay-title = "Run an Application: fuzzel";
                spawn = [ "fuzzel" ];
              };

              "Mod+O" = {
                repeat = false;
                toggle-overview = null;
              };

              "Mod+Q" = {
                repeat = false;
                close-window = null;
              };

              # Basic navigation
              "Mod+Left" = {
                focus-column-left = null;
              };
              "Mod+Down" = {
                focus-window-down = null;
              };
              "Mod+Up" = {
                focus-window-up = null;
              };
              "Mod+Right" = {
                focus-column-right = null;
              };
              "Mod+H" = {
                focus-column-left = null;
              };
              "Mod+J" = {
                focus-window-down = null;
              };
              "Mod+K" = {
                focus-window-up = null;
              };
              "Mod+L" = {
                focus-column-right = null;
              };

              "Mod+Ctrl+Left" = {
                move-column-left = null;
              };
              "Mod+Ctrl+Down" = {
                move-window-down = null;
              };
              "Mod+Ctrl+Up" = {
                move-window-up = null;
              };
              "Mod+Ctrl+Right" = {
                move-column-right = null;
              };
              "Mod+Ctrl+H" = {
                move-column-left = null;
              };
              "Mod+Ctrl+J" = {
                move-window-down = null;
              };
              "Mod+Ctrl+K" = {
                move-window-up = null;
              };
              "Mod+Ctrl+L" = {
                move-column-right = null;
              };

              "Mod+Home" = {
                focus-column-first = null;
              };
              "Mod+End" = {
                focus-column-last = null;
              };
              "Mod+Ctrl+Home" = {
                move-column-to-first = null;
              };
              "Mod+Ctrl+End" = {
                move-column-to-last = null;
              };

              # Monitor movement
              "Mod+Shift+Left" = {
                focus-monitor-left = null;
              };
              "Mod+Shift+Down" = {
                focus-monitor-down = null;
              };
              "Mod+Shift+Up" = {
                focus-monitor-up = null;
              };
              "Mod+Shift+Right" = {
                focus-monitor-right = null;
              };
              "Mod+Shift+H" = {
                focus-monitor-left = null;
              };
              "Mod+Shift+J" = {
                focus-monitor-down = null;
              };
              "Mod+Shift+K" = {
                focus-monitor-up = null;
              };
              "Mod+Shift+L" = {
                focus-monitor-right = null;
              };

              "Mod+Shift+Ctrl+Left" = {
                move-column-to-monitor-left = null;
              };
              "Mod+Shift+Ctrl+Down" = {
                move-column-to-monitor-down = null;
              };
              "Mod+Shift+Ctrl+Up" = {
                move-column-to-monitor-up = null;
              };
              "Mod+Shift+Ctrl+Right" = {
                move-column-to-monitor-right = null;
              };
              "Mod+Shift+Ctrl+H" = {
                move-column-to-monitor-left = null;
              };
              "Mod+Shift+Ctrl+J" = {
                move-column-to-monitor-down = null;
              };
              "Mod+Shift+Ctrl+K" = {
                move-column-to-monitor-up = null;
              };
              "Mod+Shift+Ctrl+L" = {
                move-column-to-monitor-right = null;
              };

              # WORKSPACE / DESKTOP SWITCHING & MOVING (this was the part you were missing)
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

              "Mod+Shift+Page_Down" = {
                move-workspace-down = null;
              };
              "Mod+Shift+Page_Up" = {
                move-workspace-up = null;
              };
              "Mod+Shift+U" = {
                move-workspace-down = null;
              };
              "Mod+Shift+I" = {
                move-workspace-up = null;
              };
            };
          };
        }).wrapper;
    in
    {
      # This is the important part — make the official module use our wrapped version
      programs.niri = {
        enable = true;
        package = niri-wrapped;
      };
    };
}

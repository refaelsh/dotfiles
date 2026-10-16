{ ... }:
{
  # Systray for xmonad and dwm. nixpkgs removed trayer because it links
  # GTK2. tint2 is a GTK3 panel; this config keeps only the notification
  # area, 26px tall, on the XRandR primary output. That is the Dell on
  # HDMI-1 while the cable is connected, and the internal panel when it
  # is not. A numeric monitor index is the HDMI port and the icon
  # disappears with the cable. The panel shrinks to the icons and sits
  # in the same bottom strip as xmobar, so it does not add a second row.
  # This file is rewritten on every switch.
  flake.nixosModules.tint2 =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.tint2 ];

      system.activationScripts.tint2-tray = lib.stringAfter [ "users" ] ''
        mkdir -p /home/refaelsh/.config/tint2
        cat > /home/refaelsh/.config/tint2/tray.tint2rc << 'EOF'
        rounded = 0
        border_width = 0
        background_color = #282A36 100
        border_color = #282A36 100

        panel_items = S
        # 240 is the maximum width. tint2 draws that once, then shrinks to
        # the icons and keeps the right edge on the monitor.
        panel_size = 240 26
        panel_shrink = 1
        panel_margin = 0 0
        panel_padding = 0 0 2
        panel_background_id = 1
        wm_menu = 0
        panel_dock = 0
        panel_position = bottom right horizontal
        panel_layer = bottom
        panel_monitor = primary
        autohide = 0
        strut_policy = follow_size
        panel_window_name = tint2
        disable_transparency = 1
        mouse_effects = 0

        systray_padding = 2 1 2
        systray_background_id = 1
        systray_sort = right2left
        systray_icon_size = 22
        systray_monitor = primary
        EOF
        chown -R refaelsh:users /home/refaelsh/.config/tint2
        chmod 644 /home/refaelsh/.config/tint2/tray.tint2rc
      '';
    };
}

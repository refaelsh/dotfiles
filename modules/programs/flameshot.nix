{ inputs, ... }:
{
  # Flameshot for PrintScreen (bound in xmonad.hs as `flameshot gui`).
  #
  # Flameshot 14+ defaults to the XDG Desktop Portal for capture. On bare
  # X11 + xmonad there is no portal, so capture fails with
  # "Could not locate the org.freedesktop.portal.Desktop service".
  # useX11LegacyScreenshot restores the old direct-X11 path — the minimal
  # fix for a none+xmonad session, and what Flameshot recommends for bare WMs.
  #
  # Alternative: enable xdg-desktop-portal + xdg-desktop-portal-gtk
  # (xdg.portal.enable / extraPortals) and drop the legacy flag. Prefer that
  # if we need portals for Flatpak, browser screen-share, or a Wayland move;
  # on pure X11 it is extra always-on D-Bus machinery for the same capture.
  #
  # Flameshot 14 also prompts to pick a monitor on multi-monitor setups
  # (overlay across all screens is no longer the default). captureActiveMonitor
  # skips that dialog and captures the monitor under the cursor instead —
  # closest to the old single-step gui workflow on X11.
  flake.nixosModules.flameshot =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.flameshot ];

      system.activationScripts.flameshot-config = lib.stringAfter [ "users" ] ''
        mkdir -p /home/refaelsh/.config/flameshot
        cat > /home/refaelsh/.config/flameshot/flameshot.ini << 'EOF'
        [General]
        useX11LegacyScreenshot=true
        captureActiveMonitor=true
        EOF

        chown -R refaelsh:users /home/refaelsh/.config/flameshot
        chmod 644 /home/refaelsh/.config/flameshot/flameshot.ini
      '';
    };
}

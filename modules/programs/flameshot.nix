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

      # Set only the two keys this session needs. Replacing the whole ini
      # on every switch threw away save path, UI, and anything else set
      # from the Flameshot window.
      system.activationScripts.flameshot-config = lib.stringAfter [ "users" ] ''
        ini=/home/refaelsh/.config/flameshot/flameshot.ini
        mkdir -p /home/refaelsh/.config/flameshot
        if [[ ! -f $ini ]]; then
          printf '%s\n' '[General]' > "$ini"
        fi
        if ! grep -q '^\[General\]' "$ini"; then
          printf '\n%s\n' '[General]' >> "$ini"
        fi
        set_flameshot_key() {
          local key="$1" value="$2"
          if grep -qE "^''${key}[[:space:]]*=" "$ini"; then
            sed -i -E "s|^''${key}[[:space:]]*=.*|''${key}=''${value}|" "$ini"
          else
            sed -i "/^\[General\]/a ''${key}=''${value}" "$ini"
          fi
        }
        set_flameshot_key useX11LegacyScreenshot true
        set_flameshot_key captureActiveMonitor true
        chown refaelsh:users /home/refaelsh/.config/flameshot "$ini"
        chmod 755 /home/refaelsh/.config/flameshot
        chmod 644 "$ini"
      '';
    };
}

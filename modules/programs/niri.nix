{ inputs, ... }:
{
  # Dendritic feature for niri (Wayland compositor)
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;

        # Optional: your niri config (you can expand this)
        settings = {
          # Example minimal config - customize as needed
          spawn-at-startup = [
            "waybar"
            # "dunst"
            # "swaybg -i /path/to/wallpaper.jpg"
          ];

          # Keyboard layout
          input.keyboard.xkb = {
            layout = "us";
            # variant = "";
          };

          # General preferences
          prefer-no-csd = true;
          cursor.hide-when-typing = true;
        };
      };

      # Required for niri to work nicely
      environment.systemPackages = with pkgs; [
        niri
        xwayland-satellite # for X11 apps
      ];
    };
}

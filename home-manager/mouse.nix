{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    size = 8;
    package = pkgs.adwaita-icon-theme;
  };

  # home.pointerCursor.gtk.enable = true;
}

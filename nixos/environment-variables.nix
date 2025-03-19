{
  environment.variables = {
    EDITOR = "nvim";
    TERM = "wezterm";
    TERMINAL = "wezterm";
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enables Ozone Wayland support for Chromium-based apps
  };
}

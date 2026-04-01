{ inputs, ... }:
{
  # Correct dendritic pattern
  flake.nixosModules.kitty = { config, lib, pkgs, ... }:
  {
    # 1. Install Kitty system-wide
    environment.systemPackages = [ pkgs.kitty ];

    # 2. Full config (exact same as your old Home-Manager version)
    environment.etc."xdg/kitty/kitty.conf".text = ''
      font_family      FiraCode Nerd Font
      font_size        12

      # Theme (Dracula is shipped with Kitty)
      include dracula.conf

      # Your settings
      confirm_os_window_close 0
      enable_audio_bell       no
      cursor_shape            beam
      cursor_blink_interval   0
      scrollback_lines        10000
      allow_remote_control    yes
      shell_integration       enabled
    '';
  };
}

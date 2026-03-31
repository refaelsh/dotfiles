{ pkgs, ... }:
{
  flake.nixosModules.kitty =
    { config, lib, ... }:
    {
      programs.kitty = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font";
          size = 12;
        };
        theme = "Dracula";
        settings = {
          confirm_os_window_close = 0;
          enable_audio_bell = false;
          cursor_shape = "beam";
          cursor_blink_interval = 0;
          scrollback_lines = 10000;
          allow_remote_control = true;
          shell_integration = "enabled";
        };
      };
    };
}

{ pkgs, ... }:
{
  flake.nixosModules.kitty =
    { config, lib, ... }:
    {
      programs.kitty = {
        enable = true;

        # All your current settings copied 1:1
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

        # Extra config if you had any in extraConfig
        extraConfig = ''
          # Put any extra kitty.conf lines here if you had them
        '';
      };
    };
}

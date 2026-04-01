{ inputs, ... }:

{
  flake.nixosModules.kitty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (inputs.wrappers.wrapperModules.kitty.apply {
          inherit pkgs;

          # Your exact original settings (passed straight to the official module)
          settings = {
            font_family = "FiraCode Nerd Font";
            font_size = 12;
            include = "dracula.conf";
            confirm_os_window_close = 0;
            enable_audio_bell = "no";
            cursor_shape = "beam";
            cursor_blink_interval = 0;
            scrollback_lines = 10000;
            allow_remote_control = "yes";
            shell_integration = "enabled";
          };
        }).wrapper
      ];
    };
}

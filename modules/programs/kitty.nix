{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  # Official Dracula theme — fetched once, never inlined in your dotfiles
  draculaTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dracula/kitty/master/dracula.conf";
    sha256 = lib.fakeSha256; # ← Nix will tell you the correct hash on first build
  };
in
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.kitty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (inputs.wrappers.wrapperModules.kitty.apply {
          inherit pkgs;

          settings = {
            font_family = "FiraCode Nerd Font";
            font_size = 12;
            confirm_os_window_close = 0;
            enable_audio_bell = "no";
            cursor_shape = "beam";
            cursor_blink_interval = 0;
            scrollback_lines = 10000;
            allow_remote_control = "yes";
            shell_integration = "enabled";

            # Absolute include — this is the clean solution
            include = draculaTheme;
          };
        }).wrapper
      ];
    };
}

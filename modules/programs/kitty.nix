{ inputs, pkgs, ... }:
{
  # Dendritic flake-parts wrapper (Lassulus style)
  flake.nixosModules.kitty =
    { lib, pkgs, ... }:
    let
      # ── Official Dracula Kitty theme (pinned forever) ─────────────────────────
      draculaRev = "87717a3f00e3dff0fc10c93f5ff535ea4092de70";

      draculaTheme = pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "kitty";
        rev = draculaRev;
        sha256 = "sha256-78PTH9wE6ktuxeIxrPp0ZgRI8ST+eZ3Ok2vW6BCIZkc=";
      };
    in
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

            # shell_integration = "disabled";

            shell = "bash -i";

            # Absolute path to the pinned theme
            include = "${draculaTheme}/dracula.conf";
          };
        }).wrapper
      ];
    };
}

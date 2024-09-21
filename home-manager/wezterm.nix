{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = # lua
      ''
        local wezterm = require 'wezterm'
        local config = {}

        config.font = wezterm.font 'Fira Code'
        config.window_close_confirmation = 'NeverPrompt'
        config.color_scheme = 'Dracula (Official)'
        config.front_end = "WebGpu"
        config.enable_tab_bar = false
        config.audible_bell = "Disabled"
        config.visual_bell = {
          fade_in_function = 'EaseIn',
          fade_in_duration_ms = 150,
          fade_out_function = 'EaseOut',
          fade_out_duration_ms = 150,
        }
        config.colors = {
          visual_bell = '#bd93f9',
        }

        return config
      '';
  };
}

{
  programs.kitty = {
    enable = true;
    themeFile= "Dracula";
    settings = {
      confirm_os_window_close = 0;
    };
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    keybindings = {
      "ctrl+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
    };
  };
}

{
  programs.alacritty = {
    enable = true;
    settings = {
      key_bindings = [
        {
          key = "V";
          mods = "Control";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control";
          action = "Copy";
        }
      ];
      font.normal = {
        family = "FiraCode Nerd Font Mono";
      };
    };
  };
}

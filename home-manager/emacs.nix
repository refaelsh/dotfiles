{ pkgs, inputs, ... }:
{
  # xdg.configFile."emacs/init.el".source = ./init.el;
  home.file.".emacs.d/init.el".source = ./init.el;
}

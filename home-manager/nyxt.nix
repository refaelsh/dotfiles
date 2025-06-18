{ pkgs, inputs, ... }:
{
  # programs.nyxt = {
  #   enable = true;
  # };

  # home.file.".config/nyxt/config.lisp".source = ./nyxt-config.lisp;
  xdg.configFile."nyxt/config.lisp".source = ./nyxt-config/config.lisp;
  xdg.configFile."nyxt/statusline.lisp".source = ./nyxt-config/statusline.lisp;
  xdg.configFile."nyxt/stylesheet.lisp".source = ./nyxt-config/stylesheet.lisp;
}

{ pkgs, inputs, ... }:
{
  # programs.nyxt = {
  #   enable = true;
  # };

  # home.file.".config/nyxt/config.lisp".source = ./nyxt-config.lisp;
  xdg.configFile."nyxt/config.lisp".source = ./nyxt-config/config.lisp;
}

{ pkgs, inputs, ... }:
{
  # programs.nyxt = {
  #   enable = true;
  # };

  home.file.".config/nyxt/config.lisp".source = ./nyxt-config.lisp;
}

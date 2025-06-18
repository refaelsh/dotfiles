{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # programs.nyxt = {
  #   enable = true;
  # };

  # home.file.".config/nyxt/config.lisp".source = ./nyxt-config.lisp;
  xdg.configFile."nyxt/config.lisp".source = config.lib.file.mkOutOfStoreSymlink "nyxt-config.lisp";
}

{
  config,
  pkgs,
  inputs,
  ...
}:
let
  configDir = builtins.dirOf (builtins.toString ./.);
in
{
  # programs.nyxt = {
  #   enable = true;
  # };

  # home.file.".config/nyxt/config.lisp".source = ./nyxt-config.lisp;
  xdg.configFile."nyxt/config.lisp".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}nyxt-config.lisp";
}

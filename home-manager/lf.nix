{ pkgs, ... }:
{
  xdg.configFile."lf/icons".source = pkgs.fetchurl {
    url = "https://github.com/gokcehan/lf/blob/master/etc/icons.example";
    sha256 = "sha256-20VeJfroHHk6N8oN5Mv0offYFrJXgPaqUYfexLvHv7c=";
  };
  programs.lf = {
    enable = true;

    settings = {
      icons = true;
      hidden = true;
      drawbox = true;
    };
  };
}

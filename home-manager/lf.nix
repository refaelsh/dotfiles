{ pkgs, ... }:
{
  xdg.configFile."lf/icons".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
    sha256 = "sha256-c0orDQO4hedh+xaNrovC0geh5iq2K+e+PZIL5abxnIk=";
    name = "icons";
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

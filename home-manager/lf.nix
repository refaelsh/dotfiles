{ pkgs, ... }:
{
  xdg.configFile."lf/icons".source = pkgs.fetchurl {
    url = "https://github.com/gokcehan/lf/blob/master/etc/icons.example";
    # You might need to specify sha256 or another hash to ensure integrity
    # sha256 = "your-hash-here";
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

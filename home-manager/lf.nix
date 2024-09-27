{ pkgs, ... }:
let
  pv = pkgs.writeShellScriptBin "pv.sh" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
        ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
        exit 1
    fi

    ${pkgs.pistol}/bin/pistol "$file"
  '';
  cl = pkgs.writeShellScriptBin "cl.sh" ''
    ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
  '';
in
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
      previewer = "${pv}/bin/pv.sh";
      cleaner = "${cl}/bin/cl.sh";
    };
  };
}

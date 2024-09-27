{ pkgs, ... }:
let
  rawUrl = "https://raw.githubusercontent.com/gokcehan/lf/refs/heads/master/etc/icons.example";
  fetchedFile = pkgs.fetchurl {
    url = rawUrl;
    sha256 = "sha256-20VeJfroHHk6N8oN5Mv0offYFrJXgPaqUYfexLvHv7c=";
  };
  myRawFile =
    pkgs.fetchFromGitHub {
      owner = "gokcehan";
      repo = "lf";
      rev = "master"; # Can be a branch, tag, or commit hash
      sha256 = "sha256-WljTws+z1qKOHHr5/K6xXKvkDNqbpfVepHcTBlIKQU0=";
    }
    + "/ect/icons.exaple";
in
{
  # xdg.configFile."lf/icons".source = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/gokcehan/lf/refs/heads/master/etc/icons.example";
  #   sha256 = "sha256-20VeJfroHHk6N8oN5Mv0offYFrJXgPaqUYfexLvHv7c=";
  # };
  xdg.configFile."lf/icons".source = (builtins.readFile myRawFile);

  programs.lf = {
    enable = true;

    settings = {
      icons = true;
      hidden = true;
      drawbox = true;
    };

    extraConfig =
      let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
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
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in
      ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
  };
}

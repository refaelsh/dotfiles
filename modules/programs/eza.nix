{ inputs, ... }:
{
  flake.nixosModules.eza =
    { lib, pkgs, ... }:
    let
      draculaRev = "add4c72c546992b8db674d6d3eea315bf2111b9a";

      draculaTheme = pkgs.fetchFromGitHub {
        owner = "eza-community";
        repo = "eza-themes";
        rev = draculaRev;
        sha256 = "sha256-toqj3bv2kCC2FHbGfeFpS3g9DoxQeZ7cwPYVpD8cfgg=";
      };

      ezaConfigDir = pkgs.runCommand "eza-dracula-config" { } ''
        mkdir -p $out
        cp ${draculaTheme}/themes/dracula.yml $out/theme.yml
      '';
    in
    {
      environment.systemPackages = [
        (inputs.wrappers.lib.wrapPackage {
          inherit pkgs;

          package = pkgs.eza;

          flags = {
            "--icons" = "auto";
            "--color" = "auto";
            "--git" = true;
            "-a" = true;
            "-F" = true;
            "--long" = true;
            "--extended" = true;
            "--header" = true;
          };

          env.EZA_CONFIG_DIR = ezaConfigDir;

        })
      ];

      environment.shellAliases.ls = null;
    };
}

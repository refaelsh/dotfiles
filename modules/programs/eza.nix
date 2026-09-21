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
      environment = {
        # NixOS defaults `ls` to `ls --color=tty` (a GNU ls flag eza rejects)
        # and `l` / `ll` to `ls -alh` / `ls -l`. Those have to be replaced,
        # not stacked on the wrapper: wrapPackage aliases are symlinks to one
        # binary, so baking --long/-a/--git into it made every name the same
        # listing. -h is also eza's "header", not GNU ls "human-readable".
        shellAliases = {
          ls = null;
          ll = "eza -l --git --header";
          la = "eza -la --git --header";
          l = "eza -l --header";
          lt = "eza --tree";
        };

        systemPackages = [
          (inputs.wrappers.lib.wrapPackage {
            inherit pkgs;

            package = pkgs.eza;

            # Icons, colour, and file-type markers on every invocation,
            # including the short `ls`. Git status and the long format are
            # opt-in via the aliases above; on a big repo `ls` must not
            # stat every file.
            flags = {
              "--icons" = "auto";
              "--color" = "auto";
              "-F" = true;
            };

            env.EZA_CONFIG_DIR = ezaConfigDir;

            # The wrapped executable is named eza. This name is what `ls`
            # resolves to once the shell alias above is removed.
            aliases = [ "ls" ];
          })
        ];
      };
    };
}

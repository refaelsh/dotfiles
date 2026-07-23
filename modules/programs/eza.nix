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
        # Clear any prior ls alias so the wrapped binary wins for plain ls.
        shellAliases = {
          ls = null;
          # Long/tree variants are shell aliases so plain `ls` stays a short
          # listing. Shared base flags (icons/color/git) come from the wrapper.
          ll = "eza --long --header --extended";
          la = "eza --long --all --header --extended";
          l = "eza --long --header";
          lt = "eza --tree --level=2";
        };

        systemPackages = [
          (inputs.wrappers.lib.wrapPackage {
            inherit pkgs;

            package = pkgs.eza;

            flags = {
              "--icons" = "auto";
              "--color" = "auto";
              "--git" = true;
              "-F" = true;
            };

            env.EZA_CONFIG_DIR = ezaConfigDir;

            # Only short-name `ls` is a full wrapper alias. Long forms use
            # shellAliases above so they are not forced into --long always.
            aliases = [ "ls" ];
          })
        ];
      };
    };
}

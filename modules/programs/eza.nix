{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # ── Official Dracula theme for eza (pinned forever) ───────────────────────
  # From the community-maintained eza-themes repo (contains dracula.yml)
  # This is the exact theme your Home-Manager was using.
  # If you ever want to update (very rare), change the rev + sha256.
  draculaRev = "add4c72c546992b8db674d6d3eea315bf2111b9a";

  draculaTheme = pkgs.fetchFromGitHub {
    owner = "eza-community";
    repo = "eza-themes";
    rev = draculaRev;
    sha256 = lib.fakeSha256; # ← Nix will print the correct hash on first build
  };
in
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.eza =
    { pkgs, ... }:
    let
      eza-wrapped = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.eza;

        # Exact same flags as your old Home-Manager programs.eza
        flags = {
          "--icons" = "auto";
          "--git" = true;
          "-a" = true;
          "-F" = true;
          "--long" = true;
          "--extended" = true;
          "--header" = true;

          # Dracula theme (absolute path to the pinned .yml)
          "--theme" = "${draculaTheme}/themes/dracula.yml";
        };
      };
    in
    {
      environment.systemPackages = [ eza-wrapped ];
    };
}

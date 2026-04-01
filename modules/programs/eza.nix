{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.eza =
    { lib, pkgs, ... }:
    let
      # ── Official Dracula theme for eza (pinned forever) ─────────────────────
      # Exact same theme your Home-Manager was using (from eza-community/eza-themes)
      draculaRev = "add4c72c546992b8db674d6d3eea315bf2111b9a";

      draculaTheme = pkgs.fetchFromGitHub {
        owner = "eza-community";
        repo = "eza-themes";
        rev = draculaRev;
        sha256 = lib.fakeSha256; # ← Nix will print the correct hash on first build
      };
    in
    {
      # Install Dracula theme system-wide so --theme=dracula works everywhere
      environment.etc."xdg/eza/themes/dracula.yml".source = "${draculaTheme}/themes/dracula.yml";

      environment.systemPackages = [
        (inputs.wrappers.lib.wrapPackage {
          inherit pkgs;

          package = pkgs.eza;

          # Exact same flags as your previous Home-Manager programs.eza
          flags = {
            "--icons" = "auto";
            "--git" = true;
            "-a" = true;
            "-F" = true;
            "--long" = true;
            "--extended" = true;
            "--header" = true;
            "--theme" = "dracula";
          };
        })
      ];
    };
}

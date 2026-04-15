{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.bat =
    { pkgs, ... }:
    let
      bat-wrapped = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.bat;

        flags = {
          "--style" = "header,grid,numbers,changes,snip";
          "--theme" = "Dracula";
          "--pager" = "less --RAW-CONTROL-CHARS";
        };
      };
    in
    {
      environment = {
        shellAliases = {
          # cat = "bat";
        };

        # systemPackages = [ bat-wrapped ];
      };

      programs.bat = {
        bat.enable = true;
        bat.package = bat-wrapped;
      };
    };
}

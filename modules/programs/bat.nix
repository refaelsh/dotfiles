{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.bat =
    { pkgs, ... }:
    let
      bat-wrapped = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.bat;

        env = {
          BAT_THEME = "Dracula";
        };
      };
    in
    {
      environment.systemPackages = [ bat-wrapped ];
    };
}

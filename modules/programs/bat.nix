{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.bat =
    { pkgs, ... }:
    let
      bat-wrapped = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.bat;

        # Defaults that match your Kitty Dracula theme
        env = {
          BAT_THEME = "Dracula";
          BAT_PAGING = "auto"; # or "never" / "always" if you prefer
        };
      };
    in
    {
      environment.systemPackages = [ bat-wrapped ];
    };
}

{ inputs, ... }:

{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.bat =
    { pkgs, ... }:
      bat-wrapped = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.bat;

        # Defaults (you can still override any of these in your Home-Manager config)
        env = {
          BAT_THEME = "Dracula"; # matches your Kitty theme
        };
    }
}

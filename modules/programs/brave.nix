{ inputs, ... }:
let
  # Bring wrappers into scope for the module below
  wrappers = inputs.wrappers;
in
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.brave =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      brave-wrapped = wrappers.lib.wrapPackage {
        inherit pkgs;

        package = pkgs.brave;

        # Exact equivalent of your original commandLineArgs
        flags = {
          "--disable-background-networking" = true;
          "--disable-default-apps" = true;
          "--disable-features" = "TranslateUI";
        };

        # Brave (and many Chromium-based browsers) expect --flag=value syntax
        flagSeparator = "=";
      };
    in
    {
      # Brave with your exact flags — now using the wrappers library
      environment.systemPackages = [ brave-wrapped ];
    };
}

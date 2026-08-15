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

        # wrapPackage already rewrites share/applications/*.desktop so Exec=
        # points at this wrapper (not the unwrapped store brave). Also install
        # brave.desktop as an alias of brave-browser.desktop so older MIME
        # names and "brave.desktop" refs still launch the same flagged binary.
        patchHook = ''
          if [[ -e $out/share/applications/brave-browser.desktop ]]; then
            cp -L --remove-destination \
              $out/share/applications/brave-browser.desktop \
              $out/share/applications/brave.desktop
          fi
        '';
      };
    in
    {
      # Brave with your exact flags — now using the wrappers library
      environment.systemPackages = [ brave-wrapped ];
    };
}

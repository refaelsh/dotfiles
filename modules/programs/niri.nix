{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;

          settings = {
            spawn-at-startup = [
              "waybar"
            ];

            # In your dendritic niri feature/module
            settings.binds."Mod+Return" = {
              spawn = [ "${pkgs.kitty}/bin/kitty" ]; # ← list, not string
              # optional but nice for the hotkey overlay
              hotkey-overlay-title = "Open terminal";
            };
          };
        }).wrapper;
    in
    {
      environment.systemPackages = [ niri-wrapped ];
    };
}

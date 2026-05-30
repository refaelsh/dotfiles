{ inputs, ... }:

{
  # Dendritic feature — exactly matches your old Home-Manager config
  flake.nixosModules.mangohud =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        mangohud # 64-bit
      ];

      # Global MangoHud overlay disabled. It was injecting into every
      # graphical application and adding CPU overhead across the desktop
      # (browsers, terminals, window manager, etc.).
      #
      # To use MangoHud for games, set the variable per-launch:
      #   MANGOHUD=1 mangohud steam
      # or wrap specific game launchers.
      # environment.variables.MANGOHUD = "1";
    };
}

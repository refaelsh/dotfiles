{ ... }:
{
  flake.nixosModules.grok-bot =
    { pkgs, inputs, ... }:
    {
      environment.systemPackages = [
        inputs.grok-bot.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      # Login redirects open sand:// URLs. Without this, the browser cannot
      # hand the callback back to the app after Sign in with Cursor.
      xdg.mime.defaultApplications."x-scheme-handler/sand" = "grok-bot.desktop";
    };
}

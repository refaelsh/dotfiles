{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/default-applications.nix
  flake.nixosModules.default-applications =
    { ... }:
    {
      xdg.mime.defaultApplications = {
        # Brave ships brave-browser.desktop (and com.brave.Browser.desktop).
        # There is no brave.desktop file; that name would make xdg-open miss
        # the browser whenever ~/.config/mimeapps.list is absent.
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/about" = "brave-browser.desktop";
        "x-scheme-handler/unknown" = "brave-browser.desktop";
      };
    };
}

{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--disable-background-networking"
      "--disable-default-apps"
      "--disable-features=TranslateUI"
    ];
  };
}

{
  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "identity.fxaccounts.enabled" = true;
      "font.name.serif.x-western" = "Fira Code";
      "font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
    };
  };
}

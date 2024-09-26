{ lib, ... }:
{
  environment.variables = {
    EDITOR = "nvim";
    TERM = "wezterm";
    TERMINAL = "wezterm";
  };

  environment.etc."brave/settings.json".text = lib.generators.toJSON { } {
    # # This is a placeholder. You would map your settings here.
    # homepage = config.brave.settings.homepage or "about:blank";
    # # Example setting, might not correspond directly to about:config but illustrates the concept
    # "browser.newtabpage.activity-stream.feeds.section.highlights" =
    #   config.brave.settings.showHighlights or false;
    # Example setting, might not correspond directly to about:config but illustrates the concept
    "browser.newtabpage.activity-stream.feeds.section.highlights" = "true";
  };
}

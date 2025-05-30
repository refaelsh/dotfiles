{
  programs = {
    zsh.enable = true;
    nm-applet.enable = true;
    dconf.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gamemode.enable = true;
    # adb.enable = true;

    xwayland.enable = true;
    niri.enable = true;
  };
}

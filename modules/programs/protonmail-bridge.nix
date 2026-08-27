{ ... }:
{
  # Headless Proton Mail Bridge so Grok Bot can talk IMAP/SMTP to
  # refaelsh@pm.me. Proton does not expose those protocols on the public
  # internet; Bridge decrypts mail locally and listens on 127.0.0.1
  # (IMAP 1143, SMTP 1025). This machine has no personal mail client —
  # the daemon is only for the bot.
  flake.nixosModules.protonmail-bridge =
    { pkgs, ... }:
    {
      services.protonmail-bridge = {
        enable = true;
        # Bridge talks to the Secret Service through gnome-keyring. The
        # binary has to be on the unit PATH or it exits with "no keychain".
        path = [ pkgs.gnome-keyring ];
        logLevel = "info";
      };

      # xmonad + LightDM do not start a Secret Service on their own.
      # gnome-keyring is the backend Proton documents for Linux; enabling
      # it also installs the PAM hook that starts the daemon on session
      # (D-Bus activation covers the rest).
      services.gnome.gnome-keyring.enable = true;

      systemd.user.services = {
        # LightDM autologin never types a password, so PAM may not start
        # gnome-keyring. Start the secrets component so Bridge can store
        # its vault. Use the capability wrapper so the daemon can mlock
        # its pages. An empty-password login keyring unlocks on start;
        # a passworded one stays locked until unlocked in the session.
        protonmail-bridge-keyring = {
          description = "Start gnome-keyring secrets for Proton Mail Bridge";
          wantedBy = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = pkgs.writeShellScript "protonmail-bridge-keyring" ''
              # --start reuses a running daemon and the parent exits, which
              # is what a oneshot needs. Do not pass --unlock: that form
              # keeps a second daemon in the foreground.
              /run/wrappers/bin/gnome-keyring-daemon --start --components=secrets
            '';
          };
        };

        protonmail-bridge = {
          after = [ "protonmail-bridge-keyring.service" ];
          wants = [ "protonmail-bridge-keyring.service" ];
          serviceConfig.RestartSec = "5s";
        };
      };
    };
}

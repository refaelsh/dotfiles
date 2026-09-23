{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old base system settings
  flake.nixosModules.system =
    { pkgs, ... }:
    {
      # On-disk compatibility stamp, not the NixOS release that is running.
      # Modules use it to keep old data directories and account defaults.
      # It was 24.05 on the original install and is now 26.05. Do not change
      # it again, including not setting it to whatever unstable currently
      # reports: a newer value switches those modules to the new behavior
      # and assumes the disk already matches.
      system.stateVersion = "26.05";
      # copySystemConfiguration = true;

      # /tmp is on the root NVMe, not a tmpfs. A RAM-backed /tmp would compete
      # with zram on this 8 GiB machine and push reclaim onto the disk swap
      # partition. Still delete leftover temp files at boot so they do not
      # accumulate as flash writes across sessions.
      boot.tmp.cleanOnBoot = true;

      # Disabled to avoid pulling in large amounts of development documentation
      # and man pages for every package in the system profile.
      documentation.dev.enable = false;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.android_sdk.accept_license = true;

      time.timeZone = "Asia/Jerusalem";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
      };

      environment.pathsToLink = [ "/share/zsh" ];
    };
}

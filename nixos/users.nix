{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    users.refaelsh = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "storage"
        "adbusers"
      ];
      useDefaultShell = true;
    };
  };
}

{ inputs, ... }:

{
  flake.nixosModules.security = { ... }:
    {
      security = {
        rtkit.enable = true;
        sudo = {
          extraRules = [
            {
              users = [ "refaelsh" ];
              commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
            }
          ];
        };
      };
    };
}

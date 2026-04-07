{ inputs, ... }:
{
  flake.nixosModules.environment-shell-aliases =
    { ... }:
    {
    environment.shellAliases = {
      ls = null;
      cat = ["bat"];
    };
}

{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.bat =
    { pkgs, ... }:
    let
      bat-wrapped =
        (inputs.wrappers.wrapperModules.bat.apply {
          inherit pkgs;
          "bat-config".content = ''
            # bat configuration (migrated from old wrapPackage flags)
            # see: https://github.com/sharkdp/bat/blob/master/README.md#configuration-file
            style = header,grid,numbers,changes,snip
            theme = Dracula
            pager = "less --RAW-CONTROL-CHARS"
          '';
        }).wrapper;
    in
    {
      environment = {
        shellAliases = {
          cat = "bat";
        };
      };

      programs.bat = {
        enable = true;
        package = bat-wrapped;
      };
    };
}

{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # interactiveShellInit works because Ghostty (and most modern terminals) launch interactive shells.
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;

        blesh.enable = true;

        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd
        '';

        # Starship prompt setup.
        # We do this in promptInit (like the old programs.starship module did)
        # because it gives better cooperation with blesh.enable = true.
        # The actual Starship binary + config comes 100% from the wrapper.
        promptInit = ''
          if [[ $TERM != "dumb" ]]; then
            eval "$(starship init bash --print-full-init)"
          fi
        '';
      };
    };
}

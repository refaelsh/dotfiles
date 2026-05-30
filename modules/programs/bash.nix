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

          # Starship initialization.
          # We fully rely on the wrappers-wrapped starship binary (which has
          # STARSHIP_CONFIG forced via the wrapper environment). The NixOS
          # programs.starship module is intentionally not used.
          if [[ $TERM != "dumb" ]]; then
            eval "$(starship init bash --print-full-init)"
          fi
        '';
      };
    };
}

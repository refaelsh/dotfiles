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

          # Starship initialization (fully driven by the wrapper).
          # We intentionally do NOT use programs.starship.enable.
          #
          # blesh is also enabled via programs.bash.blesh.enable. The ordering
          # here matters: Starship init should run late in interactiveShellInit.
          # After a rebuild you usually need a completely fresh shell (or `exec bash`)
          # because old hook registrations from the previous NixOS starship module
          # can still be active in existing shell sessions.
          if [[ $TERM != "dumb" ]]; then
            eval "$(starship init bash --print-full-init)"
            # If ble.sh is already attached, re-attach so it can re-take control
            # of the prompt after Starship has installed its hooks.
            [[ ${BLE_VERSION-} ]] && ble-attach 2>/dev/null || true
          fi
        '';
      };
    };
}

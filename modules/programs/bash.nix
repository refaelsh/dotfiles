{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # interactiveShellInit works because Ghostty (and most modern terminals) launch interactive shells.
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;

        # We disable the automatic blesh module because its internal prompt
        # hook management conflicts with Starship and causes the entire prompt
        # (including the directory module) to render twice.
        blesh.enable = false;

        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # === Manual ble.sh + Starship initialization (full control) ===
          # This ordering is the one recommended by both Starship and ble.sh
          # documentation to avoid double prompts.
          source ${pkgs.blesh}/share/blesh/ble.sh --noattach

          # Starship — fully driven by our wrapper (config + binary).
          if [[ $TERM != "dumb" ]]; then
            eval "$(starship init bash --print-full-init)"
          fi

          # Must be the absolute last thing in interactiveShellInit.
          [[ ''${BLE_VERSION-} ]] && ble-attach
        '';
      };
    };
}

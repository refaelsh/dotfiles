{ inputs, pkgs, ... }:
{
  # Dendritic flake-parts wrapper (Lassulus style) — migrated from kitty.nix
  flake.nixosModules.ghostty =
    { lib, pkgs, ... }:
    let
      # Dracula is shipped as a built-in resource theme in Ghostty 1.x ("Dracula" and "Dracula+").
      # No need to fetchFromGitHub like we did for the Kitty version.
    in
    {
      environment.systemPackages = [
        (inputs.wrappers.wrapperModules.ghostty.apply {
          inherit pkgs;

          settings = {
            font-family = "FiraCode Nerd Font";
            font-size = 12;

            # Built-in theme — matches previous Dracula Kitty setup.
            theme = "Dracula";

            confirm-close-surface = false;
            bell-features = "no-audio,no-attention";

            cursor-style = "bar";          # "beam" equivalent in Ghostty
            cursor-style-blink = false;

            # Adapted from the Kitty 4000-line reduction (2026-05) because the
            # Grok TUI is extremely verbose (long reasoning traces, subagent output,
            # monitor streams, per-call terminal capture logs). The real history
            # lives in ~/.grok/sessions/... anyway. 64 MiB is still very generous
            # for normal terminal use and for Ghostty's byte-based limit.
            scrollback-limit = 64 * 1024 * 1024;  # 64 MiB

            window-decoration = false;
            window-padding-x = 0;
            window-padding-y = 0;

            # Mouse wheel (and trackpad) scrolling was feeling too fast/snappy.
            # Lower values scroll fewer lines per tick. 0.5 is a common starting
            # point for people coming from Kitty or wanting more precision.
            mouse-scroll-multiplier = 0.5;

            # Disable Ghostty's built-in shell integration.
            # We are running a complex custom prompt stack (ble.sh + Starship
            # driven by the wrapper). Ghostty's integration injects its own
            # prompt hooks which easily cause double (or triple) rendering of
            # the prompt, especially the directory module.
            shell-integration = "none";

            # Convenient for mouse-driven selection workflows (pairs well with Grok).
            copy-on-select = "clipboard";

            # Safe bindings that do not hijack the critical shell Ctrl+C (interrupt).
            # Users coming from the old Kitty ctrl+c=copy_and_clear_or_interrupt mapping
            # can adapt or add more advanced conditional keybinds later.
            keybind = [
              "ctrl+shift+c=copy_to_clipboard"
              "ctrl+shift+v=paste_from_clipboard"
            ];
          };
        }).wrapper
      ];
    };
}

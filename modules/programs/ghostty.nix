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
            # Our Starship prompt (initialized from bash) manages the full
            # prompt; the terminal integration can inject conflicting hooks
            # that cause duplicate or broken rendering.
            shell-integration = "none";

            # Convenient for mouse-driven selection workflows (pairs well with Grok).
            copy-on-select = "clipboard";

            # Copy/paste bindings chosen for GUI-style muscle memory while preserving
            # terminal semantics where it matters.
            #
            # - ctrl+v always pastes from the clipboard (what you asked for).
            # - performable:ctrl+c copies only when there is a selection; otherwise the
            #   key passes through unchanged. This means Ctrl+C still sends SIGINT to
            #   interrupt a running program in the shell, or does whatever the app
            #   expects when no text is selected.
            # - The ctrl+shift variants are kept as well for discoverability and
            #   anyone used to the classic terminal Shift bindings.
            #
            # Tradeoff: plain Ctrl+V no longer reaches the pty, so it cannot be used
            # for readline's "literal next" or Vim's visual block selection. We
            # provide Ctrl+Q as the fallback inside Neovim (see nixvim keymaps).
            # Inserting a literal control character is rare enough that this is the
            # usual compromise.
            keybind = [
              "ctrl+shift+c=copy_to_clipboard"
              "ctrl+shift+v=paste_from_clipboard"
              "performable:ctrl+c=copy_to_clipboard"
              "ctrl+v=paste_from_clipboard"
            ];
          };
        }).wrapper
      ];
    };
}

{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager.
  # interactiveShellInit works because Ghostty (and most modern terminals)
  # launch interactive shells. This gives a fast, zsh-like interactive
  # experience without the overhead of zsh or ble.sh. Atuin augments Ctrl-R
  # with advanced history search, stats and context (while preserving Up/Down
  # prefix search and the lightweight readline approach).
  flake.nixosModules.bash =
    { pkgs, ... }:
    {
      programs.bash = {
        enable = true;

        # Neutralize the base module's classic prompt so Starship has full
        # control (prevents duplicate or overwritten PS1).
        promptInit = "";

        interactiveShellInit = ''
          # Some environments have had paste artifacts; keep explicit for now.
          bind 'set enable-bracketed-paste off'

          # Zsh-like ergonomics and safety features (lightweight, no hooks).
          shopt -s \
            autocd \
            cdspell \
            dirspell \
            checkwinsize \
            cmdhist \
            direxpand \
            extglob \
            globstar \
            histappend \
            nocaseglob 2>/dev/null || true

          # Rich shared history (like zsh with share and ignore options).
          export HISTSIZE=100000
          export HISTFILESIZE=200000
          export HISTCONTROL=ignoreboth:erasedups
          export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:date:clear:history"

          # Propagate history to other shells immediately (zsh-like behavior).
          PROMPT_COMMAND="history -a; history -n''${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

          # === Readline tweaks for zsh-like completion (via bind, no /etc/inputrc) ===
          # Case-insensitive, menu-style, colored completions.
          bind 'set completion-ignore-case on'
          bind 'set show-all-if-ambiguous on'
          bind 'set colored-stats on'
          bind 'set colored-completion-prefix on'
          bind 'set menu-complete-display-prefix on'
          bind 'set completion-map-case on'
          bind 'set visible-stats on'
          bind 'set mark-symlinked-directories on'

          # Up/Down arrows perform prefix history search (incremental, very zsh-like).
          bind '"\e[A": history-search-backward'
          bind '"\e[B": history-search-forward'
          # Shift-Tab walks the completion menu backward.
          bind '"\e[Z": menu-complete-backward'

          # fzf keybindings (Ctrl-R history via atuin, Ctrl-T = insert file path,
          # Alt-C = cd into dir) and programmable completion (including **<tab>).
          # fzf supplies file/dir selection; atuin gives advanced history on Ctrl-R.
          if command -v fzf-share >/dev/null 2>&1; then
            FZF_SHARE_DIR="$(fzf-share)"
            if [ -r "$FZF_SHARE_DIR/key-bindings.bash" ]; then
              source "$FZF_SHARE_DIR/key-bindings.bash"
            fi
            if [ -r "$FZF_SHARE_DIR/completion.bash" ]; then
              source "$FZF_SHARE_DIR/completion.bash"
            fi
          fi

          # Starship prompt must initialize before atuin. Starship needs to claim
          # PROMPT_COMMAND to render the prompt and to wrap/preserve the history
          # PROMPT_COMMAND we set above. Atuin always populates precmd_functions
          # and preexec_functions arrays (when the shell is interactive). Starship
          # detects non-empty arrays and switches to array-based hooks instead of
          # setting PROMPT_COMMAND. Without Ghostty shell-integration (disabled to
          # avoid duplicate hooks) there is no bash-preexec driver to invoke the
          # arrays before each prompt, so starship would never run and you'd get
          # the plain "bash-5.3$" default prompt.
          if [[ $TERM != "dumb" ]]; then
            eval "$(starship init bash --print-full-init)"
          fi

          # Atuin: advanced history (fuzzy, stats, dir/host filtering, sync). Replaces/enhances Ctrl-R.
          # We keep Up/Down as prefix search (the readline binds above) via --disable-up-arrow.
          # Works alongside our PROMPT_COMMAND history sharing and Starship.
          if command -v atuin >/dev/null 2>&1; then
            eval "$(atuin init bash --disable-up-arrow)"
          fi
        '';
      };
    };
}

{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager.
  # interactiveShellInit works because Ghostty (and most modern terminals)
  # launch interactive shells. This gives a fast, zsh-like interactive
  # experience without the overhead of zsh or ble.sh.
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

          # fzf keybindings (Ctrl-R = fuzzy history, Ctrl-T = insert file path,
          # Alt-C = cd into dir) and programmable completion. This is the
          # lightweight replacement for zsh autosuggest + fzf-tab.
          if [ -r "${pkgs.fzf}/share/fzf/shell/key-bindings.bash" ]; then
            source "${pkgs.fzf}/share/fzf/shell/key-bindings.bash"
          fi
          if [ -r "${pkgs.fzf}/share/fzf/shell/completion.bash" ]; then
            source "${pkgs.fzf}/share/fzf/shell/completion.bash"
          fi

          # Starship prompt. Dracula colors and layout are defined in the
          # starship wrapper module; we only perform the init here.
          if [[ $TERM != "dumb" ]]; then
            eval "$(starship init bash --print-full-init)"
          fi
        '';
      };
    };
}

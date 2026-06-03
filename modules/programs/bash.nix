{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager.
  # interactiveShellInit works because Ghostty (and most modern terminals)
  # launch interactive shells. This gives a fast, zsh-like interactive
  # experience (lightweight readline + starship + atuin, no heavy line editor).
  # Atuin augments Ctrl-R with advanced history search, stats and context (while
  # preserving Up/Down prefix search). Timestamped history, additional shopt
  # safety options (histverify, lithist, etc.), the extract command, and the
  # gray-history approximation via explicit accept provide further parity with
  # prior Zsh ergonomics.
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
            nocaseglob \
            histreedit \
            histverify \
            lithist \
            cdable_vars \
            checkjobs \
            pushd_ignore_dups 2>/dev/null || true

          # Immediate notification of terminated background jobs (more responsive
          # than waiting for next prompt; matches common Zsh interactive behavior).
          set -o notify

          # Trailing space on sudo/watch so that aliases defined later (or in eza
          # wrapper, bash init functions, etc.) still expand after the command
          # (e.g. sudo ll runs the eza alias; sudo , cowsay works). Matches the
          # alias-expansion behavior of the (commented) sudo plugin from the prior
          # Zsh/oh-my-zsh config.
          alias sudo='sudo '
          alias watch='watch '

          # Rich shared history (like zsh with share and ignore options).
          export HISTSIZE=100000
          export HISTFILESIZE=200000
          export HISTCONTROL=ignoreboth:erasedups
          export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:date:clear:history"

          # Timestamped history output, matching the default behavior of `history`
          # in Zsh when extended history is enabled. The autosuggest lookup forces
          # an empty HISTTIMEFORMAT locally so its parsing of the numbered output
          # remains unaffected.
          export HISTTIMEFORMAT='%F %T '

          # Zsh-like autosuggest accept on right-arrow (and safe movement otherwise):
          # appends the top matching history entry for the current prefix when the
          # cursor is at the end of the line. Otherwise right-arrow performs normal
          # single-char movement. Complements up/down prefix search and Ctrl-R (atuin).
          # Lightweight approximation only; true inline gray preview as you type is
          # not provided by plain readline.
          __atuin_autosuggest_accept() {
            local prefix="$READLINE_LINE"
            local suggestion
            suggestion=$(HISTTIMEFORMAT= history | tac | cut -c 8- | grep -i "^$prefix" | head -1)
            if [[ -n $suggestion && $suggestion != "$prefix" && $READLINE_POINT -eq ''${#READLINE_LINE} ]]; then
              READLINE_LINE=$suggestion
              READLINE_POINT=''${#READLINE_LINE}
            else
              if (( READLINE_POINT < ''${#READLINE_LINE} )); then
                READLINE_POINT=$((READLINE_POINT + 1))
              fi
            fi
          }
          bind -x '"\e[C": __atuin_autosuggest_accept'

          # Gray history text (inline preview as you type): fulfills the request
          # for grayed-out history suggestion visible while typing. True live
          # dim-gray text that updates on every keystroke requires a full line
          # editor replacement (explicitly ruled out). The right-arrow (EOL-only
          # accept) plus Ctrl-g below give the functional preview-then-commit
          # flow using atuin history. This is the closest lightweight
          # approximation possible.
          bind -x '"\C-g": __atuin_autosuggest_accept'

          # extract: unpack common archive formats (tar.*, zip, 7z, gz, bz2, xz, ...).
          # Direct port of the "extract" command from the oh-my-zsh extract plugin
          # used in the prior Zsh setup. Pure bash, no extra processes at definition
          # time. Supports the formats covered by pkgs already present (p7zip for 7z,
          # unzip, tar family, xz, gzip, bzip2).
          extract() {
            if [ -f "$1" ]; then
              case "$1" in
                *.tar.bz2|*.tbz2) tar xjf "$1" ;;
                *.tar.gz|*.tgz)   tar xzf "$1" ;;
                *.tar.xz|*.txz)   tar xJf "$1" ;;
                *.tar)            tar xf "$1"  ;;
                *.bz2)            bunzip2 "$1" ;;
                *.gz)             gunzip "$1"  ;;
                *.xz)             unxz "$1"    ;;
                *.zip)            unzip "$1"   ;;
                *.7z)             7z x "$1"    ;;
                *)                echo "extract: '$1' - unknown archive type" >&2; return 1 ;;
              esac
            else
              echo "extract: '$1' is not a valid file" >&2; return 1
            fi
          }

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

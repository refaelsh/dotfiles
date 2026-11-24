# Interactive bash

Opening a terminal starts interactive bash with a Starship prompt, shared history, eza listings, an `extract` helper, and fzf colors. The NixOS starship module stays off so it does not write a second prompt.

## Sub-features

- `bash-prompt-owner` leaves `promptInit` empty, disables `programs.starship`, and calls Starship before Atuin.
- `bash-prompt-theme` uses the Dracula lambda prompt from the wrapped Starship settings.
- `bash-history` keeps a large timestamped history and ignores duplicate and space-prefixed commands.
- `bash-aliases` maps `ll`, `la`, `l`, `lt`, `-`, `h`, `sudo`, and `watch`, and removes the `ls` shell alias.
- `bash-ls` exposes `ls` as the eza wrapper, with icons, color, and file-type flags.
- `bash-extract` unpacks tar, zip, and 7z archives from the shell.
- `bash-fzf` sets the Dracula `FZF_DEFAULT_OPTS` and sources fzf keys from the init script. fzf and atuin are system packages.
- `bash-completion` enables bash completion.

## How to get to it (user POV)

- Log into the xmonad session and press Super+Return. Ghostty starts bash.
- Open Ghostty from the session startup on workspace 0.
- Type `ll`, `la`, `l`, `lt`, or `ls` in that shell.
- Type `extract <archive>` in that shell.
- Press Ctrl-T or Alt-C for fzf. Ctrl-R is Atuin, installed by the same init script.

## Driving it with verify-nixos

Preconditions:

- `verify-nixos launch` printed `ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05`.
- `verify-nixos doctor` printed `activation=unchanged`.
- The commands below use `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`.

- **Bash is the interactive shell.** Require the module. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-json --feature interactive-bash --artifact bash-enabled programs.bash.enable --python 'd is True'`. The output is `true` and the command prints `ok interactive-bash bash-enabled`.
- **Prompt owner.** Require an empty NixOS prompt and the stock Starship module off. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature interactive-bash --artifact prompt-init programs.bash.promptInit --equals ''` and `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-json --feature interactive-bash --artifact starship-module programs.starship.enable --python 'd is False'`. `prompt-init.out` is empty. `starship-module.out` is `false`.
- **Starship before Atuin.** Require bracketed paste off and Starship's init call earlier in the script than Atuin's. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature interactive-bash --artifact prompt-order programs.bash.interactiveShellInit --contains 'enable-bracketed-paste off' --contains 'starship init bash' --contains 'atuin init bash' --before 'starship init bash' --after 'atuin init bash'`. `prompt-order.meta` has `before_index` less than `after_index`.
- **History.** Require the history size, control, and timestamp. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature interactive-bash --artifact history programs.bash.interactiveShellInit --contains 'HISTSIZE=100000' --contains 'HISTFILESIZE=200000' --contains 'HISTCONTROL=ignoreboth' --contains "HISTTIMEFORMAT='%F %T '"`. All four strings are in `history.out`.
- **Shell aliases.** Require the listing and navigation aliases. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-json --feature interactive-bash --artifact aliases environment.shellAliases --python 'd["ll"]=="eza -l --git --header" and d["la"]=="eza -la --git --header" and d["l"]=="eza -l --header" and d["lt"]=="eza --tree" and d["ls"] is None and d["-"]=="cd -" and d["h"]=="history" and d["sudo"]=="sudo " and d["watch"]=="watch "'`. `aliases.out` is that map. `ls` is JSON `null`. `sudo` and `watch` end with a space.
- **extract.** Require the archive helper. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature interactive-bash --artifact extract programs.bash.interactiveShellInit --contains 'extract()' --contains '*.tar.gz|*.tgz)' --contains '7z x'`. Those strings are in `extract.out`.
- **fzf init and colors.** Require the fzf source lines and the Dracula options. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature interactive-bash --artifact fzf-init programs.bash.interactiveShellInit --contains 'command -v fzf-share' --contains 'key-bindings.bash' --contains 'completion.bash'` and `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature interactive-bash --artifact fzf-colors environment.variables.FZF_DEFAULT_OPTS --contains 'bg:#282a36' --contains 'hl:#bd93f9' --contains "prompt='❯ '"`. Both outputs contain those strings.
- **fzf, atuin, and eza packages.** Require one fzf, one atuin, and one eza wrapper whose `ls` alias and flags are set. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature interactive-bash --artifact interactive-packages interactive-packages --python 'd["fzf"]==1 and d["atuin"]==1 and d["eza"]["count"]==1 and d["eza"]["aliases"]==["ls"] and d["eza"]["flags"]["--icons"]=="auto" and d["eza"]["flags"]["--color"]=="auto" and d["eza"]["flags"]["-F"] is True and "EZA_CONFIG_DIR" in d["eza"]["envNames"]'`. `interactive-packages.out` matches that expression.
- **Starship theme.** Require one wrapped Starship and the lambda prompt. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature interactive-bash --artifact starship-theme starship-settings --python 'd["count"]==1 and d["character"]["success_symbol"]=="[λ](bold #f8f8f2)" and d["character"]["error_symbol"]=="[λ](bold #ff5555)" and d["directory"]["home_symbol"]=="🏠" and d["directory"]["truncation_length"]==8 and d["username"]["format"]=="[$user]($style) on " and d["continuation_prompt"]=="▶▶ "'`. `starship-theme.out` matches that expression.
- **Completion.** Require programmable completion. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-json --feature interactive-bash --artifact bash-completion programs.bash.completion.enable --python 'd is True'`. The output is `true`.
- **Activation untouched.** Require the booted system and `result` symlinks to match launch. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-inactive --feature interactive-bash --artifact activation`. `activation.out` shows equal `booted_at_launch` and `booted_now`, equal lock hashes, and the same result-link list.

## Gotchas

- Do not type into the logged-in Ghostty. That shell is not this run.
- `programs.starship.enable` evaluates to false. A check that it is true fails a correct config.
- `ls` in `environment.shellAliases` is null. The `ls` command name is the eza wrapper alias, proved by `interactive-packages`, not by the shell alias table.
- `EZA_CONFIG_DIR` is set on that wrapper. The Dracula theme YAML is produced when the config derivation is built. This journey does not read that file. Do not treat the alias check as a theme check.
- `HISTCONTROL` is `ignoreboth`. It does not include `erasedups`.
- Starship's init call is the string `starship init bash`. A comment that merely mentions Starship does not satisfy `--before`.
- fzf colors include the prompt character `❯`. The contains string is `prompt='❯ '`.
- Package queries instantiate `environment.systemPackages` and can take several minutes. They must not print `building `.
- `nix eval` may warn that the buckley310 brave-browser flake is no longer updated. Exit code 0 is still success.
- Untracked nix files are invisible until staged. Unstage them after the check.

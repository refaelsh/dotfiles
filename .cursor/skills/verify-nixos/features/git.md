# Git

`git` runs as a wrapped binary with this user's name and email, short aliases, a delta pager, and pull set to rebase. `delta` is also installed on its own so the pager exists.

## Sub-features

- `git-identity` sets `user.name` to `refaelsh` and `user.email` to `refaelsh@pm.me`.
- `git-aliases` defines `st`, `ch`, `diff`, `show`, and `lg`.
- `git-delta` sets the pager and interactive filter path to delta, selects the Dracula side-by-side theme, and installs the `delta` package.
- `git-defaults` starts repositories on `master` and rebases on pull.

## How to get to it (user POV)

- Run `git status` or `git st` in a repository.
- Run `git lg` for the graph log.
- Run `git diff` and `git show`. Both use delta.
- Run `git pull` on a tracking branch. It rebases.
- Run `git init`. The first branch is `master`.

## Driving it with verify-nixos

Preconditions:

- `verify-nixos launch` printed `ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05`.
- `verify-nixos doctor` printed `activation=unchanged`.
- The commands below use `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`.

- **Identity.** Require one git wrapper and the user fields. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature git --artifact identity git-settings --python 'd["count"]==1 and d["user"]["name"]=="refaelsh" and d["user"]["email"]=="refaelsh@pm.me"'`. `identity.out` matches that expression.
- **Aliases.** Require the short commands. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature git --artifact aliases git-settings --python 'd["alias"]["st"]=="status" and d["alias"]["ch"]=="checkout" and d["alias"]["diff"]=="diff --color-moved --submodule" and d["alias"]["show"]=="show --color-moved" and "lg" in d["alias"]'`. `aliases.out` matches that expression. `lg` is present; its format string is long and is not compared character for character.
- **Delta.** Require the pager, the theme, and the package. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature git --artifact delta git-settings --python 'd["hasDelta"] is True and d["core"]["pager"]=="delta" and d["delta"]["syntax-theme"]=="Dracula" and d["delta"]["side-by-side"] is True and d["delta"]["line-numbers"] is True and d["delta"]["navigate"] is True'`. `delta.out` matches that expression.
- **Defaults.** Require the initial branch and pull rebase. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature git --artifact defaults git-settings --python 'd["init"]["defaultBranch"]=="master" and d["pull"]["rebase"]=="true"'`. `defaults.out` matches that expression. `rebase` is the string `true`, not a JSON boolean.
- **Activation untouched.** Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-inactive --feature git --artifact activation`. `activation.out` shows the same booted path and the same result-link list as launch.

## Gotchas

- Do not run `git config --global` in the user home. That reads the booted generation, which can differ from this flake.
- Settings come from the wrapped package queried as `git-settings`, not from `programs.git`.
- `count` must be 1. A second package that sets `GIT_CONFIG_GLOBAL` makes the journey fail.
- `pull.rebase` is the string `"true"`.
- `hasDelta` is package presence. `core.pager` is the config string `delta`. Both are required.
- Color tables and `safe.directory` are part of the same settings attribute. This journey does not assert every color key.
- The query instantiates `environment.systemPackages` and can take several minutes. It must not build git or delta.

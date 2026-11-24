# myNixos verification map

This directory is the maintained source for verifying user-facing behavior of the `myNixos` flake. Read this index, then use the matching feature file as the recipe.

## Baseline preconditions

- The helper is `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`.
- Launch first. Scratch `/tmp/verify-nixos/<run-id>` starts empty. Do not copy the home directory into it.
- Ready output includes `ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05`.
- Run `verify-nixos doctor` and require `activation=unchanged` plus the same host, session, and user.
- Drive only the run this verification started. `current` is the latest launch. Source that run's `instance.env` when it is not current.
- Do not run `update.sh`, `nixos-rebuild`, `nix build`, or `nix flake update`.
- Ignore `misc/`. It is not imported by the flake.

## Driving conventions

- Start every recipe from the launched instance unless its preconditions say otherwise.
- Treat every command as literal. Keep option paths, query names, and Python expressions unchanged.
- NixOS option paths and the query names in the skill are the stable handles.
- `query` prints a value and does not record proof. Journeys use `assert-json`, `assert-raw`, `assert-query`, and `assert-inactive`.
- End a full feature run with `assert-inactive`. Cleanup must not delete the evidence directory.

## Proof and skip reporting

- Capture the eval output and the assertion, not only the `ok` line.
- Assertion proof includes `<artifact>.out`, `<artifact>.meta`, and `<artifact>.stderr`.
- Order checks also record `before_index` and `after_index` in the meta file.
- Activation proof includes the booted system path and the `result` symlink list from launch and from the end of the drive.
- Record the feature id and artifact name on every command.
- Report an unreachable path with the command and the unmet precondition.
- Do not report a skipped entry point as verified through a different path.
- A green eval does not mean the booted generation matches the flake.

## Feature entry contract

Each feature file starts with an H1 title and one paragraph describing the user-visible behavior. It then uses exactly four H2 sections in this order.

1. `Sub-features` lists short IDs with one line for each behavior.
2. `How to get to it (user POV)` lists every user entry point.
3. `Driving it with verify-nixos` starts with `Preconditions:` and uses labeled bullets that pair each user action with an exact command and observable result.
4. `Gotchas` lists traps that can waste or invalidate a verification run.

Keep implementation details out of the map. Name user paths, stable handles, required state, commands, and observable proof.

## Features

- [Interactive bash](./interactive-bash.md) covers the Starship prompt, history, aliases, `extract`, fzf colors, and the eza `ls` name.
- [xmonad session](./xmonad-session.md) covers LightDM login, keys, startup clients, and the Ghostty terminal those keys launch.
- [Neovim](./neovim.md) covers the default editor, leader, key bindings, and editing options.
- [Git](./git.md) covers identity, aliases, delta, and pull defaults.
- [Web links](./web-links.md) covers opening HTML and http(s) links in Brave.

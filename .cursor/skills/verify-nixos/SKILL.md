---
name: verify-nixos
description: >
  Verify the live myNixos NixOS flake (nixosConfigurations.myNixos) by
  evaluating the login session, interactive bash, Neovim, Git, and default
  browser settings. Use when a change to this dotfiles repo needs proof
  that user-facing behavior still evaluates, without building or switching
  the running system.
---

# Verify myNixos

This repo is the live NixOS configuration `nixosConfigurations.myNixos`. The user logs in through LightDM to xmonad, opens Ghostty, and gets interactive bash, Neovim, Git, and Brave. There is no app server and no database. Verification reads that configuration with `nix eval`. It does not build a system closure and it does not switch the booted generation. The user activates changes with `update.sh`.

`misc/` is not part of the flake. Do not verify it.

The helper is `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`. It finds the flake from its own path. Run that file, not a copy.

## Launch

Launch creates an empty scratch directory and evaluates the login sentinels. Scratch starts empty: no home directory, no history file, no copy of `/etc`. There is nothing to migrate or seed. The fixture is the flake.

```bash
/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos launch
```

Ready is this line, printed only after the sentinels match:

```text
ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05
```

The same command then prints `run=`, `evidence=`, `scratch=`, and `instance=`. Scratch is `/tmp/verify-nixos/<run-id>`. Evidence is `${XDG_STATE_HOME:-$HOME/.local/state}/verify-nixos/evidence/<run-id>`.

Those sentinels are `networking.hostName`, `services.displayManager.defaultSession`, `services.displayManager.autoLogin.enable`, `services.displayManager.autoLogin.user`, `services.xserver.displayManager.lightdm.enable`, `services.xserver.windowManager.xmonad.enable`, `users.users.refaelsh.isNormalUser`, `programs.bash.enable`, `system.stateVersion`, and `nixpkgs.hostPlatform.system`.

A first eval may unpack locked flake inputs. That is not a build and not a switch. If stderr contains a line starting with `building `, the helper refuses the run.

`current` points at the latest launch. Two runs can evaluate at the same time. They do not share scratch or evidence. For any run that is not `current`, `source` its `instance.env` so `VERIFY_NIXOS_RUN` is set before `doctor`, `assert-*`, or `cleanup`. Do not point two runs at one evidence directory.

Do not launch by logging into LightDM, opening the existing Ghostty, or running `update.sh`, `nixos-rebuild`, `nix build`, or `nix flake update`.

## Doctor

Run doctor before driving whenever a result looks wrong. It is read-only. It re-evaluates the sentinels, re-reads the booted system, and checks that this run still owns its scratch.

```bash
/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos doctor
```

Healthy output:

```text
doctor ok run=<id> host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05 nixpkgs=<rev> booted=</nix/store/...> activation=unchanged
```

Doctor fails when there is no instance, the scratch marker is missing, the flake path is not this repo, the sentinels changed, `flake.lock` changed, the nixpkgs rev changed, `/run/current-system` changed, or a `result` / `result-*` symlink in the flake directory appeared or moved. A failure means this instance is not worth driving. Fix the reported check or launch again. Do not switch generations to make doctor pass.

`nixos-version` on the booted system can differ from the flake under review. Doctor does not compare them.

`nix eval` prints this on stderr while the brave-browser input is still wired in:

```text
evaluation warning: The buckley310/brave-browser-nix flake is no longer updated, because nixpkgs has re-added their brave package.
```

The helper stores that stderr and still succeeds when the exit code is 0. Do not treat the warning as a failed doctor, and do not edit the brave input as part of driving a journey.

## Drive

Read `features/README.md`, then the feature file. Run that file's commands. A journey that cannot meet its preconditions fails and the reason belongs in that file's Gotchas. Do not skip an entry point and report a different path as proof.

The harness reads `nixosConfigurations.myNixos.config`. Option paths are the stable handles for NixOS settings. Named queries are the stable handles for values that live on wrapper passthru. `query` prints a value and does not record proof. Proving a feature uses `assert-json`, `assert-raw`, `assert-query`, and `assert-inactive`.

```bash
SCRIPT=/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos
"$SCRIPT" query session
"$SCRIPT" assert-json --feature interactive-bash --artifact bash-enabled programs.bash.enable --python 'd is True'
"$SCRIPT" assert-query --feature git --artifact identity git-settings --python 'd["count"]==1 and d["user"]["name"]=="refaelsh"'
"$SCRIPT" assert-inactive --feature interactive-bash --artifact activation
```

| Query | What it evaluates |
| --- | --- |
| `session` | hostname, LightDM, auto-login, default session, xmonad enable, dwm enable, user, bash, stateVersion, host platform |
| `bash-init` | `programs.bash.interactiveShellInit` |
| `shell-aliases` | `environment.shellAliases` |
| `fzf-opts` | `environment.variables.FZF_DEFAULT_OPTS` |
| `nixvim` | editor enablement, aliases, Dracula, leader, number, expandtab, undodir |
| `nixvim-keymaps` | keymap `mode`, `key`, and `action` |
| `xmonad-config` | the Haskell string in `services.xserver.windowManager.xmonad.config` |
| `git-settings` | the wrapped git package's settings (`GIT_CONFIG_GLOBAL`) plus whether `delta` is a system package |
| `starship-settings` | the wrapped starship package's settings (`STARSHIP_CONFIG`) |
| `ghostty-settings` | the wrapped ghostty package's settings (font, theme, shell integration, keybinds) |
| `mime` | `xdg.mime.defaultApplications` |
| `interactive-packages` | eza wrapper aliases and flags, and the fzf and atuin package counts |

`git-settings`, `starship-settings`, `ghostty-settings`, and `interactive-packages` instantiate `environment.systemPackages`. That can take several minutes. Wait for the command to exit. They still must not build.

Untracked `.nix` files are invisible to a git flake. A new module has to be staged for the eval to see it, then unstaged with `git restore --staged` when the check is done. Edits to tracked files are visible without staging.

Do not drive the logged-in xmonad or Ghostty. That session was not started by this run. Do not run `git config --global` or `xdg-open` against the booted generation.

## Evidence

Proof files live in the evidence directory printed by launch:

`${XDG_STATE_HOME:-$HOME/.local/state}/verify-nixos/evidence/<run-id>/<feature>/<artifact>.out`

Each assert also writes `<artifact>.meta` (run id, flake, nixpkgs rev, booted path, exit code, and order indexes when the command checked order) and `<artifact>.stderr`. `<feature>/commands.log` lists every assert.

A proof exercises the configuration `update.sh` would activate. Capture the command's stdout and the assertion, not only `ok`. For bash aliases the proof is the evaluated alias map. For prompt order the proof is the init script plus `before_index` and `after_index` in the meta file. For activation the proof is `activation.out`, which records `/run/current-system` and the flake's `result` symlinks at launch and at the end of the drive. Those paths must match. Eval does not open a terminal, so a rendered prompt is not the proof.

There is no mock. The brave-browser warning is real stderr from the locked input. A dry-run flag is not used. Passing eval does not mean the booted generation matches the flake, and it does not mean dwm, xmonad, or a wrapper binary was compiled.

## Cleanup

Cleanup removes the scratch directory and the run record for one run. It does not kill processes by name. The eval commands are foreground children of the helper; wait for them to exit instead of killing `nix`.

```bash
/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos cleanup
/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos cleanup <run-id>
```

Cleanup prints `cleaned <run-id> evidence kept at <evidence-dir>`. The evidence directory must still be there after cleanup, and `/tmp/verify-nixos/<run-id>` must be gone. Run cleanup after a failed launch attempt too, so a broken run does not keep a scratch directory. Evidence from the failed attempt stays.

## Helpers

The helper is executable. Invoke it by path:

```bash
SCRIPT=/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos
"$SCRIPT" launch
"$SCRIPT" doctor
"$SCRIPT" query session
"$SCRIPT" assert-json --feature interactive-bash --artifact bash-enabled programs.bash.enable --python 'd is True'
"$SCRIPT" assert-raw --feature interactive-bash --artifact prompt-init programs.bash.promptInit --equals ''
"$SCRIPT" assert-raw --feature interactive-bash --artifact prompt-order programs.bash.interactiveShellInit --contains 'starship init bash' --before 'starship init bash' --after 'atuin init bash'
"$SCRIPT" assert-query --feature git --artifact identity git-settings --python 'd["count"]==1 and d["user"]["name"]=="refaelsh"'
"$SCRIPT" assert-inactive --feature interactive-bash --artifact activation
"$SCRIPT" cleanup
```

`--python` is a Python expression over the JSON value `d`. `--contains` and `--before` / `--after` match the raw string. `--equals ''` matches `programs.bash.promptInit`, which evaluates to an empty string. Feature files in `features/` are the journeys. Keep them in sync with the queries above.

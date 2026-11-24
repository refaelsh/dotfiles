# Neovim

Neovim is the default editor. `nvim`, `vim`, and `vi` are the same program. The leader key is Space, line numbers are relative, and Ctrl-Q does what Ctrl-V used to do because Ghostty takes Ctrl-V for paste.

## Sub-features

- `nvim-default` enables nixvim, makes it the default editor, aliases `vim` and `vi`, and selects the Dracula colorscheme.
- `nvim-leader` sets the leader and local leader to Space.
- `nvim-keys` swaps `;` and `:` in normal mode and maps Ctrl-Q to Ctrl-V in normal, visual, and insert mode.
- `nvim-editing` shows absolute and relative numbers, expands tabs, and stores undo files under the user state directory.

## How to get to it (user POV)

- The xmonad session starts Neovide on workspace 0, opening this flake.
- Run `nvim`, `vim`, or `vi` from bash.
- Press Space as the leader key.
- Press `;` to open the command line, and `:` to repeat a find.
- Press Ctrl-Q for visual block or to insert the next character literally.

## Driving it with verify-nixos

Preconditions:

- `verify-nixos launch` printed `ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05`.
- `verify-nixos doctor` printed `activation=unchanged`.
- The commands below use `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`.

- **Default editor.** Require nixvim, both aliases, and Dracula. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature neovim --artifact editor nixvim --python 'd["enable"] is True and d["defaultEditor"] is True and d["vimAlias"] is True and d["viAlias"] is True and d["colorscheme"] is True'`. `editor.out` matches that expression.
- **Leader.** Require a single space. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature neovim --artifact leader nixvim --python 'd["mapleader"]==" "'`. `leader.out` has `"mapleader": " "`.
- **Keys.** Require the colon swap and the Ctrl-Q bindings. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature neovim --artifact keymaps nixvim-keymaps --python '{"mode":"n","key":";","action":":"} in d and {"mode":"n","key":":","action":";"} in d and {"mode":"n","key":"<C-q>","action":"<C-v>"} in d and {"mode":"v","key":"<C-q>","action":"<C-v>"} in d and {"mode":"i","key":"<C-q>","action":"<C-v>"} in d'`. `keymaps.out` contains those five objects.
- **Editing options.** Require numbers, expanded tabs, and the undo directory. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature neovim --artifact editing nixvim --python 'd["relativenumber"] is True and d["number"] is True and d["expandtab"] is True and d["undodir"]=="/home/refaelsh/.local/state/nvim/undo"'`. `editing.out` matches that expression.
- **Activation untouched.** Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-inactive --feature neovim --artifact activation`. `activation.out` shows the same booted path and the same result-link list as launch.

## Gotchas

- Do not read `$EDITOR` in the agent shell. That shell is not a newly activated system.
- The leader value is one space character, not the word `Space`.
- Ctrl-V is reserved by Ghostty. The Neovim binding that replaces it is Ctrl-Q, proved here as `<C-q>` mapping to `<C-v>`.
- `undodir` is `/home/refaelsh/.local/state/nvim/undo`. This journey does not create that directory and does not write an undo file.
- Byte-compiled Lua is configured. This journey does not build it.
- The keymap query drops `options` and keeps `mode`, `key`, and `action`. Assert those three fields.

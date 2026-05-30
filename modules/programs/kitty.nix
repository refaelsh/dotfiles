{ ... }:
{
  # MIGRATED TO GHOSTTY (2026)
  #
  # The active terminal configuration now lives in modules/programs/ghostty.nix.
  # This file is kept as a stub so that import-tree continues to work without error.
  # The original Kitty wrapper + Dracula pinning + Grok-specific scrollback tuning
  # has been fully ported (and improved — Ghostty ships its own Dracula theme).
  #
  # Safe to `git rm` this file in a follow-up commit once the migration is proven stable.
  flake.nixosModules.kitty = { ... }: { };
}

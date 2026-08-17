{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/fonts.nix
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts = {
        fontconfig.enable = true;

        packages = with pkgs; [
          # Unpatched Fira Code is st's primary face. A patched Nerd Font
          # already contains the icon glyphs, so st would draw those at the
          # text size and never consult font2. Symbols Only is that font2
          # fallback, sized independently so nvim-tree / starship icons fill
          # the cell. st has no Ghostty-style icon scaler.
          fira-code
          nerd-fonts.symbols-only
          nerd-fonts.inconsolata
          nerd-fonts.fira-code
          nerd-fonts.fira-mono
          hack-font
          cascadia-code
          source-code-pro
          font-awesome
          noto-fonts
          dejavu_fonts
        ];
      };
    };
}

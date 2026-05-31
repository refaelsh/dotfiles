{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old nixos/fonts.nix
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts = {
        fontconfig.enable = true;

        packages = with pkgs; [
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

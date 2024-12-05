{ pkgs, ... }:
{
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.inconsolata
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.fontawesome
      hack-font
      cascadia-code
      hasklig
      fira-code-symbols
      fira-code
      cantarell-fonts
      symbola
      source-code-pro
      font-awesome
      font-awesome_5
      font-awesome_4
      line-awesome
      powerline-fonts
      ubuntu_font_family
      mononoki
      unifont
      dejavu_fonts
      symbola
      noto-fonts
      libertine
    ];
  };
}

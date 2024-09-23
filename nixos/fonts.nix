{ pkgs, ... }:
{
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      hack-font
      nerdfonts
      cascadia-code
      hasklig
      fira-code-symbols
      fira-code
      cantarell-fonts
      inconsolata-nerdfont
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

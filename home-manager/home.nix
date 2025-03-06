{
  self,
  pkgs,
  inputs,
  nixmobar,
  ...
}:
let
  clangFormatConfig = pkgs.runCommand "clang-format-config" { buildInputs = [ pkgs.clang-tools ]; } ''
    clang-format -style=Mozilla -dump-config > $out
  '';
in
{
  home.file.".clang-format".source = clangFormatConfig;

  home.stateVersion = "24.05";

  imports = [
    ./alacritty.nix
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./fzf.nix
    ./lf.nix
    ./kitty.nix
    ./mangohud.nix
    # ./nixmobar.nix
    ./starship.nix
    ./termonad.nix
    ./wezterm.nix
    # ./xmobar.nix
    # inputs.nixmobar.homeModules.mainmodule
    ./zsh.nix
  ];
}

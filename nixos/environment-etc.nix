{ config, pkgs, ... }:
let
  # Define the clang-format configuration as a derivation
  clangFormatConfig = pkgs.runCommand "clang-format-config" { buildInputs = [ pkgs.clang-tools ]; } ''
    clang-format -style=Google -dump-config > $out
  '';
in
{
  # Option 1: Place it in /etc (system-wide)
  environment.etc."clang-format".source = clangFormatConfig;
}

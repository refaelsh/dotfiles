{
  xdg.configFile."eza/theme.yaml" = {
    text = ''
      asd
    '';
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
    extraOptions = [
      "-a"
      "-F"
      "--long"
      "--extended"
      "--header"
    ];
  };
}

# "eza -a --icons --long --extended --git --header";
#   xdg.configFile."xmobar/.xmobarrc" = {
#     text = # haskell
#       ''
#         Config {
#           font = "${cfg.font}",
#           additionalFonts = [${lib.concatMapStringsSep ", " (s: "\"" + s + "\"") cfg.additionalFonts}],
#           bgColor = "${cfg.bgColor}",
#           fgColor = "${cfg.fgColor}",
#           textOffset = ${toString cfg.textOffset},
#           verbose = ${if cfg.verbose then "True" else "False"},
#           allDesktops = ${if cfg.allDesktops then "True" else "False"},
#           lowerOnStart = ${if cfg.lowerOnStart then "True" else "False"},
#           overrideRedirect = ${if cfg.overrideRedirect then "True" else "False"},
#           position = ${cfg.position},
#           alpha = ${toString cfg.alpha},
#           commands = [${cfg.commands}],
#           alignSep = "${cfg.alignSep}",
#           template = "${cfg.template}"
#         }
#       '';
#   };
# };

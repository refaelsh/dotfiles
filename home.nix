{ config, pkgs, ...}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  programs.xmobar = {
    enable = true;
    extraConfig = # haskell
      ''
        -- :w | silent !killall -s SIGKILL xmobar; xmobar &
        Config {
          font = "Fira Code 13",
          additionalFonts = ["Fira Code 22"],
          bgColor = "#282a36",
          fgColor = "#f8f8f2",
          textOffset = 2,
          verbose = True,
          allDesktops = True,
          lowerOnStart = True,
          overrideRedirect = True,
          position = BottomH 26,
          alpha = 200,
          commands = [
            Run XMonadLog,
            Run DiskU [("/", "<fc=#bd93f9><fn=1>\xf0a0</fn></fc> <free>")] [] 50,
            Run DiskIO [("/", "<read><fc=#bd93f9> R</fc> <fc=#bd93f9>W</fc> <write>")] ["-t", "", "-w", "4"] 10,
            Run DynNetwork ["-t", "<rx>KB/s<fc=#bd93f9><fn=1>\x1F89B</fn></fc><fc=#bd93f9><fn=1>\x1F899</fn></fc><tx>KB/s", "-w", "5"] 10,
            Run Memory ["-t", "<fc=#bd93f9><fn=1>\xE266</fn></fc><usedratio>%"] 10,
            Run Swap ["-t", "<fc=#bd93f9>S</fc><usedratio>%"] 10,
            Run Kbd [],
            Run CpuFreq ["-t", "<avg>GHz"] 50,
            Run MultiCoreTemp ["-t", "<fc=#bd93f9><fn=1>\xf2c9</fn></fc><avg>°", "-L", "60", "-H", "95", "-l", "white", "-n", "white", "-h", "red"] 50,
            Run CatInt 0 "/sys/class/hwmon/hwmon4/fan1_input" [] 50,
            Run MultiCpu ["-t", "<fc=#bd93f9><fn=1>\xf4bc</fn></fc> <vbar0><vbar1><vbar2><vbar3><vbar4><vbar5><vbar6><vbar7>", "-w", "99", "-L", "3", "-H", "50", "--normal", "green", "--high", "red"] 10,
            Run BatteryP ["BAT0"] ["-t", "<fc=#bd93f9><fn=1>󱊣</fn></fc><left>%", "-L", "10", "-H", "80", "-p", "3", "--", "-O", "<fc=green>On</fc> - ", "-i", "", "-L", "-15", "-H", "-5", "-l", "red", "-m", "blue", "-h", "green", "-a", "notify-send -u critical 'Battery running out!!'", "-A", "3"] 600,
            Run Alsa "default" "Master" ["-t", "<fc=#bd93f9><fn=1>\xf028</fn></fc> <volume>%"],
            Run Date "%a %_d %b %H:%M:%S" "date" 10,
            Run Load ["-t", "<fc=#bd93f9><fn=0>L</fn></fc><load1>", "-L", "1", "-H", "3", "-d", "2"] 300,
            Run ComX "nmcli" ["-t", "-f", "SIGNAL", "dev", "wifi"] "N/A" "wifi_signal" 50,
            Run Com "uname" ["-r"] "kernel_version" 3600,
            Run XPropertyLog "_XMONAD_TRAYPAD"
          ],
          alignSep = "}{",
          template = "<hspace=8/>%XMonadLog% }{ %load%|%disku%|%diskio%|<fc=#bd93f9><fn=1></fn></fc>%wifi_signal%|%dynnetwork%|<fc=#bd93f9><fn=1>󰈐</fn></fc>%cat0%|%multicoretemp%|%cpufreq%|%multicpu%|<fc=#bd93f9><fn=1></fn></fc>%kbd%|%memory% %swap%|%battery%|%alsa:default:Master%|<fc=#bd93f9><fn=1></fn></fc>%kernel_version%|%date%|%_XMONAD_TRAYPAD%"
        }
      '';
    # commands = {
    #   date = "%a %_d %b %H:%M:%S";
    #   com = {
    #     executable = "uname";
    #     arguments = ["-r"];
    #     rate = 3600;
    #   };
    # };
  };
  # ** Librewolf
  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "identity.fxaccounts.enabled" = true;
      "font.name.serif.x-western" = "Fira Code";
      "font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
    };
  };
  # ** Fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  # ** Zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      "cat" = "bat";
      "ls" = "eza -a --icons --long --extended --git --header";
      "bbb" = "git commit";
    };
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    enableCompletion = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "regexp"
        "cursor"
        "root"
        "line"
      ];
    };
    initExtraBeforeCompInit = # bash
      ''
        fpath+=($HOME/.zsh/plugins/zsh-completions/share/zsh/site-functions)
      '';
    plugins = [
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];
    initExtra = # bash
      ''
        # Everything that follows below is Dracula theme for zsh-syntax-highlighting.
        # Taken from here: https://github.com/dracula/zsh-syntax-highlighting/blob/master/zsh-syntax-highlighting.sh.
        #+begin_src bash
        typeset -gA ZSH_HIGHLIGHT_STYLES
        ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
        ## Constants
        ## Entitites
        ## Functions/methods
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#50FA7B'
        ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#50FA7B'
        ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#50FA7B'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#50FA7B'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#bd93f9'
        ZSH_HIGHLIGHT_STYLES[precommand]='fg=#50FA7B,italic'
        ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#FFB86C,italic'
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#FFB86C'
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#FFB86C'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#BD93F9'
        ## Keywords
        ## Built ins
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8BE9FD'
        ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8BE9FD'
        ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8BE9FD'
        ## Punctuation
        ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#FF79C6'
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#FF79C6'
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#FF79C6'
        ## Serializable / Configuration Languages
        ## Storage
        ## Strings
        ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#F1FA8C'
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#F1FA8C'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#FF5555'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#FF5555'
        ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#F1FA8C'
        ## Variables
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#FF5555'
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[assign]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#F8F8F2'
        ## No category relevant in spec
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#FF79C6'
        ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#FF79C6'
        ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#BD93F9'
        #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
        #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
        #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
        #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#FF5555'
        ZSH_HIGHLIGHT_STYLES[redirection]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[arg0]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[default]='fg=#F8F8F2'
        ZSH_HIGHLIGHT_STYLES[cursor]='standout'
      '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "git"
        "git-extras"
        "git-escape-magic"
        "gitfast"
        "zsh-interactive-cd"
        "vi-mode"
        "colored-man-pages"
        "extract"
        "cp"
        "cabal"
        "fzf"
      ];
    };
  };
  # ** Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      package = {
        disabled = true;
      };
      nodejs = {
        disabled = true;
      };
      lua = {
        disabled = true;
      };
      python = {
        disabled = true;
      };
      cmd_duration = {
        disabled = true;
      };
      git_commit = {
        tag_disabled = false;
      };
      dotnet = {
        disabled = true;
      };
      cmake = {
        disabled = true;
      };
      gcloud = {
        disabled = true;
      };
      directory = {
        home_symbol = "🏠";
        truncation_length = 8;
        truncation_symbol = "…/";
      };
      # The below is taken from: https://draculatheme.com/starship.
      aws.style = "bold #ffb86c";
      cmd_duration.style = "bold #f1fa8c";
      directory.style = "bold #50fa7b";
      hostname.style = "bold #ff5555";
      git_branch.style = "bold #ff79c6";
      git_status.style = "bold #ff5555";
      username = {
        format = "[$user]($style) on ";
        style_user = "bold #bd93f9";
      };
      character = {
        success_symbol = "[λ](bold #f8f8f2)";
        error_symbol = "[λ](bold #ff5555)";
      };
      continuation_prompt = "▶▶ ";
    };
  };
  # ** Wezterm
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = # lua
      ''
        local wezterm = require 'wezterm'
        local config = {}

        config.font = wezterm.font 'Fira Code'
        config.window_close_confirmation = 'NeverPrompt'
        config.color_scheme = 'Dracula (Official)'
        config.front_end = "WebGpu"
        config.enable_tab_bar = false
        config.audible_bell = "Disabled"
        config.visual_bell = {
          fade_in_function = 'EaseIn',
          fade_in_duration_ms = 150,
          fade_out_function = 'EaseOut',
          fade_out_duration_ms = 150,
        }
        config.colors = {
          visual_bell = '#bd93f9',
        }

        return config
      '';
  };
  # programs.kitty = {
  #   enable = true;
  #   theme = "Dracula";
  #   settings = {
  #     confirm_os_window_close = 0;
  #   };
  #   font = {
  #     name = "FiraCode Nerd Font";
  #     size = 12;
  #   };
  #   keybindings = {
  #     "ctrl+c" = "copy_to_clipboard";
  #     "ctrl+v" = "paste_from_clipboard";
  #   };
  # };
  # ** Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      key_bindings = [
        {
          key = "V";
          mods = "Control";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control";
          action = "Copy";
        }
      ];
      font.normal = {
        family = "FiraCode Nerd Font Mono";
      };
    };
  };
  # ** Polybar
  #    #+BEGIN_SRC nix
  #      services.polybar.enable = true;
  #      services.polybar.script = "";
  #      services.polybar.package = pkgs.polybarFull;
  #      services.polybar.settings = {
  #        "colors" = {
  #          background = "#282a36";
  #          foreground = "#f8f8f2";
  #          primary = "#f1fa8c";
  #          secondary = "#8be9fd";
  #          disabled = "#6272a4";
  #          current_line = "#44475a";
  #          comment = "#6272a4";
  #          green = "#50fa7b";
  #          purple = "#bd93f9";
  #          red = "#ff5555";
  #          yellow = "#f1fa8c";
  #        };
  #        "settings" = {
  #          screenchange-reload = "true";
  #          pseudo-transparency = "true";
  #        };
  #        "bar/mybar" = {
  #          width = "100%";
  #          height = "30px";
  #          bottom = "true";
  #          dpi = "0";
  #          background = "\${colors.background}";
  #          foreground = "\${colors.foreground}";
  #          module-margin = "1";
  #          separator = "|";
  #          separator-foreground = "\${colors.disabled}";
  #          font-0 = "FiraCode Nerd Font;4";
  #          modules-left = "xworkspaces";
  #          modules-right = "filesystem network memory cpu xkeyboard battery date";
  #          cursor-click = "pointer";
  #          cursor-scroll = "ns-resize";
  #          enable-ipc = "true";
  #          tray-position = "right";
  #          wm-restack = "generic";
  #        };
  #        "module/xworkspaces" = {
  #          type = "internal/xworkspaces";
  #          enable-scroll = "false";
  #          label-active = "%name%";
  #          label-active-background = "\${colors.current_line}";
  #          label-active-padding = "1";
  #          label-occupied = "%name%";
  #          label-occupied-padding = "1";
  #          label-urgent = "%name%";
  #          label-urgent-background = "\${colors.red}";
  #          label-urgent-padding = "1";
  #          label-empty = "";
  #          label-empty-padding = "1";
  #        };
  #        "module/filesystem" = {
  #          type = "internal/fs";
  #          mount-0 = "/";
  #          label-mounted = "%{F#bd93f9}%{F-} %free%";
  #        };
  #        "module/network" = {
  #          type = "internal/network";
  #          interface = "enp0s3";
  #          speed-unit = "";
  #          label-connected = "%{F#bd93f9}%{F-} %downspeed:5% %{F#bd93f9}%{F-} %upspeed:5%";
  #        };
  #        "module/memory" = {
  #          type = "internal/memory";
  #          label = "%{F#bd93f9}%{F-} %percentage_used:2%% %{F#bd93f9}S%{F-} %percentage_swap_used%%";
  #        };
  #        "module/cpu" = {
  #          type = "internal/cpu";
  #          interval = 0.5;
  #          format = "%{F#bd93f9}🖥%{F-} <label> <ramp-coreload>";
  #          label = "%percentage:2%%";
  #          ramp-coreload-spacing = "1";
  #          ramp-coreload-0 = "";
  #          ramp-coreload-0-foreground = "\${colors.green}";
  #          ramp-coreload-1 = "▁";
  #          ramp-coreload-1-foreground = "\${colors.green}";
  #          ramp-coreload-2 = "▃";
  #          ramp-coreload-2-foreground = "\${colors.green}";
  #          ramp-coreload-3 = "▄";
  #          ramp-coreload-3-foreground = "\${colors.yellow}";
  #          ramp-coreload-4 = "▅";
  #          ramp-coreload-4-foreground = "\${colors.yellow}";
  #          ramp-coreload-5 = "▆";
  #          ramp-coreload-5-foreground = "\${colors.red}";
  #          ramp-coreload-6 = "▇";
  #          ramp-coreload-6-foreground = "\${colors.red}";
  #          ramp-coreload-7 = "█";
  #          ramp-coreload-7-foreground = "\${colors.red}";
  #        };
  #        "module/battery" = {
  #          type = "internal/battery";
  #          battery = "BAT0";
  #          adapter = "AC";
  #          label-full = "%{F#50fa7b}%{F-} ";
  #          format-full = "<label-full>";
  #          label-charging = "%percentage%% %time%";
  #          format-charging = " <ramp-capacity> <label-discharging>";
  #          label-discharging = " %percentage%% %time%";
  #          format-discharging = "<ramp-capacity> <label-discharging>";
  #          ramp-capacity-0 = "%{F#ff5555}%{F-}";
  #          ramp-capacity-1 = "%{F#f1fa8c}%{F-}";
  #          ramp-capacity-2 = "%{F#f1fa8c}%{F-}";
  #          ramp-capacity-3 = "%{F#f1fa8c}%{F-}";
  #          ramp-capacity-4 = "%{F#50fa7b}%{F-}";
  #        };
  #        "module/xkeyboard" = {
  #          type = "internal/xkeyboard";
  #          label-layout = "%{F#bd93f9}%{F-}  %layout%";
  #        };
  #        "module/date" = {
  #          type = "internal/date";
  #          date = "%{F#bd93f9}%{F-} %H:%M:%S";
  #        };
  #        # "module/volume" = {
  #        #   type = "internal/pulseaudio";
  #        #   format.volume = "<ramp-volume> <label-volume>";
  #        #   label.muted.text = "🔇";
  #        #   label.muted.foreground = "#666";
  #        #   ramp.volume = ["🔈" "🔉" "🔊"];
  #        #   click.right = "pavucontrol &";
  #        # };
  #        # "module/volume" = {
  #        #   type = "internal/alsa";
  #        #   format.volume = "<ramp-volume> <label-volume>";
  #        #   label.muted.text = "🔇";
  #        #   label.muted.foreground = "#666";
  #        #   ramp.volume = ["🔈" "🔉" "🔊"];
  #        #   # click.right = "pavucontrol &";
  #        # };
  #      };
  #    #+END_SRC
  programs.git = {
    enable = true;
    userEmail = "refaelsh@pm.me";
    userName = "refaelsh";
    aliases = {
      lg = "log --date-order --color-moved --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      st = "status";
      diff = "diff --color-moved --submodule";
      show = "show --color-moved";
      ch = "checkout";
    };
    extraConfig = {
      safe = {
        directory = "*";
      };
      color = {
        ui = "always";
      };
      init = {
        defaultBranch = "master";
      };
      color.branch = {
        current = "cyan bold reverse";
        local = "white";
        plain = "";
        remote = "cyan";
      };
      color.diff = {
        commit = "";
        func = "cyan";
        plain = "";
        whitespace = "magenta reverse";
        meta = "white";
        frag = "cyan bold reverse";
        old = "red";
        new = "green";
      };
      color.grep = {
        context = "";
        filename = "";
        function = "";
        linenumber = "white";
        match = "";
        selected = "";
        separator = "";
      };
      color.interactive = {
        error = "";
        header = "";
        help = "";
        prompt = "";
      };
      color.status = {
        added = "green";
        changed = "yellow";
        header = "";
        localBranch = "";
        nobranch = "";
        remoteBranch = "cyan bold";
        unmerged = "magenta bold reverse";
        untracked = "red";
        updated = "green bold";
      };
      merge = {
        ff = "no";
        tool = "kdiff3";
      };
      pull = {
        rebase = "true";
      };
    };
  };
  # ** Termonad
  xdg.configFile."termonad/termonad.hs" = {
    text = # haskell
      ''
        {-# LANGUAGE OverloadedStrings #-}  

        module Main where

        import Data.Maybe (fromMaybe)
        import Termonad
        import Termonad.Config.Colour

        main :: IO ()
        main = do
        -- First, create the colour extension based on either PaperColor modules.
        myColourExt <- createColourExtension dracula

        -- Update 'myTMConfig' with our colour extension.
        let newTMConfig = addColourExtension myTMConfig myColourExt

        -- Start Termonad with our updated 'TMConfig'.
        start newTMConfig

        -- This is our Dracula 'ColourConfig'.
        dracula :: ColourConfig (AlphaColour Double)
        dracula =
        defaultColourConfig
        { -- Set the default background & foreground colour of text of the terminal.
        backgroundColour = Set (createColour 40 42 54), -- black.0
        foregroundColour = Set (createColour 248 248 242), -- white.7
        -- Set the extended palette that has 2 Vecs of 8 Dracula palette colours
        palette = ExtendedPalette draculaNormal draculaBright
        }
        where
        draculaNormal :: List8 (AlphaColour Double)
        draculaNormal =
        fromMaybe defaultStandardColours $
        mkList8
        [ createColour 40 42 54, -- black.0
        createColour 255 85 85, -- red.1
        createColour 80 250 123, -- green.2
        createColour 241 250 140, -- yellow.3
        createColour 189 147 249, -- blue.4
        createColour 255 121 198, -- magenta.5
        createColour 139 233 253, -- cyan.6
        createColour 191 191 191 -- white.7
        ]

        draculaBright :: List8 (AlphaColour Double)
        draculaBright =
        fromMaybe defaultStandardColours $
        mkList8
        [ createColour 77 77 77, -- black.8
        createColour 255 110 103, -- red.9
        createColour 90 247 142, -- green.10
        createColour 244 249 157, -- yellow.11
        createColour 202 169 250, -- blue.12
        createColour 255 146 208, -- magenta.13
        createColour 154 237 254, -- cyan.14
        createColour 230 230 230 -- white.15
        ]

        -- This is our main 'TMConfig'.  It holds all of the non-colour settings
        -- for Termonad.
        --
        -- This shows how a few settings can be changed.
        myTMConfig :: TMConfig
        myTMConfig =
        defaultTMConfig
        { options =
        defaultConfigOptions
        { showScrollbar = ShowScrollbarNever,
        confirmExit = False,
        showMenu = False,
        cursorBlinkMode = CursorBlinkModeOn,
        fontConfig =
        defaultFontConfig
        { fontFamily = "FiraCode Nerd Font",
        fontSize = FontSizePoints 12
        }
        }
        }
      '';
  };
}

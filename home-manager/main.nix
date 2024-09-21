{ config, pkgs, ... }:
{
  # ** Fzf
  # ** Zsh
  # ** Starship
  # ** Wezterm
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

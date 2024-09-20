{
  inputs,
  system,
  config,
  pkgs,
  lib,
  ...
}:
let
in
# nixvim = import (builtins.fetchGit { 
#   url = "https://github.com/nix-community/nixvim"; 
# });
{

  imports = [
    ./hardware-configuration.nix
    # <home-manager/nixos>
    inputs.home-manager.nixosModules.home-manager
    # inputs.nixvim.nixosModules.nixvim
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot.configurationLimit = 10;
  };

  system = {
    stateVersion = "24.05";
    # copySystemConfiguration = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
    # keyboard.zsa.enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # systemd.services.numlock = {
  #   description = "Enable NumLock at startup";
  #   wantedBy = [ "multi-user.target" ]; 
  #   serviceConfig = {
  #     TTYPath = "/dev/tty1";
  #     StandardInput = "tty";
  #     StandardOutput = "tty";
  #     Type = "oneshot";
  #     RemainAfterExit = "yes";
  #     ExecStart = "${pkgs.kbd}/bin/setleds -D +num";  
  #   };
  # };

  security = {
    rtkit.enable = true;
    sudo = {
      extraConfig = "Defaults env_keep += \"HOME\"";
      extraRules = [
        {
          users = [ "refaelsh" ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };

  documentation.dev.enable = true;
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.refaelsh = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "storage"
      ];
      useDefaultShell = true;
    };
  };

  services = {
    libinput.enable = true;
    thermald.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "refaelsh";
    };
    defaultSession = "none+xmonad";
  };

  services.picom = {
    enable = true;
    backend = "glx";
  };

  services.xserver = {
    enable = true;
    resolutions = [
      {
        x = 1920;
        y = 1080;
      }
    ];
    xkb = {
      variant = "";
      layout = "us";
    };
    displayManager.lightdm.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableConfiguredRecompile = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmobar
      ];
      config = # haskell
        ''
          import XMonad
          import XMonad.Actions.Navigation2D
          import XMonad.Actions.SpawnOn
          import XMonad.Hooks.DynamicLog
          import XMonad.Hooks.EwmhDesktops
          import XMonad.Hooks.InsertPosition
          import XMonad.Hooks.ManageDocks
          import XMonad.Hooks.StatusBar
          import XMonad.Hooks.StatusBar.PP
          import XMonad.Hooks.WindowSwallowing
          import XMonad.Layout.NoBorders
          import XMonad.Layout.OneBig
          import XMonad.Layout.ToggleLayouts
          import qualified XMonad.StackSet as W
          import XMonad.Util.EZConfig
          import XMonad.Util.SpawnOnce
          import XMonad.Util.Loggers
          import qualified XMonad.Util.Hacks as Hacks
          import XMonad.Prompt
          import XMonad.Prompt.Shell

          myTerminal :: String
          myTerminal = "wezterm"

          myStartupHook :: X ()
          myStartupHook = do
            spawn "killall picom; picom &"
            spawn "keyctl link @u @s"
            spawnOnce "killall trayer; trayer --height 26 --edge bottom --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282a36"
            spawnOnce "clipmenud"
            spawnOnce "numlockx on"
            spawnOnce "setxkbmap -layout us,il -option grp:alt_shift_toggle"
            spawnOnce "kbdd"
            spawn "amixer set Master 5%-"
            spawn "amixer set Master 5%+"
            spawnOnOnce "1" "librewolf"
            spawnOnOnce "9" "signal-desktop"
            spawnOnOnce "0" "neovide ~/repos/dotfiles/configuration.org"

          myXmobarPP :: PP
          myXmobarPP = def { 
             ppCurrent = xmobarColor "#ff79c6" ""
            , ppVisible = xmobarColor "#ff79c6" "" -- . clickable
            , ppHidden = xmobarColor "#bd93f9" "" -- . wrap
            , ppTitle = xmobarColor "#e6e6e6" "" . shorten 60
            , ppSep =  "<fc=" ++ "#4d4d4d" ++ "> <fn=1>|</fn> </fc>"
            , ppUrgent = xmobarColor "#ff5555" "" . wrap "!" "!"
            , ppOrder  = \(ws:l:t:ex) -> [ws]
          }        where

          main :: IO ()
          main =
            xmonad
              . ewmhFullscreen
              . ewmh
              . docks
              . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
              $ myConfig

          myLayoutHook = avoidStruts $ smartBorders $ toggleLayouts Full (Tall 1 (3 / 100) (1 / 2))

          myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

          myConfig =
            def
              { modMask = mod4Mask,
                workspaces = myWorkspaces,
                terminal = myTerminal,
                startupHook = myStartupHook,
                manageHook = insertPosition End Newer <> (manageSpawn <+> manageHook def),
                layoutHook = myLayoutHook,
                handleEventHook = swallowEventHook (className =? "neovide") (return True) <> Hacks.trayerPaddingXmobarEventHook,
                borderWidth = 2,
                focusedBorderColor = "#bd93f9",
                normalBorderColor = "#44475a"
              }
              `additionalKeysP` [ ("M-<Return>", spawn myTerminal),
                                  ("M-d", shellPrompt def {alwaysHighlight = True, height = 30, borderColor = "#BD93F9", fgColor = "#F8F8F2", bgColor = "#282A36", fgHLight = "#F8F8F2", bgHLight = "#6272A4" }),  
                                  ("M-S-q", kill),
                                  ("M-f", sendMessage (Toggle "Full") <> sendMessage ToggleStruts),
                                  ("M-0", windows $ W.greedyView "0"),
                                  ("M-S-0", windows $ W.shift "0"),
                                  ("M-<Left>", windowGo L False),
                                  ("M-<Right>", windowGo R False),
                                  ("M-<Up>", windowGo U False),
                                  ("M-<Down>", windowGo D False),
                                  ("M-S-<Left>", windowSwap L False),
                                  ("M-S-<Right>", windowSwap R False),
                                  ("M-S-<Up>", windowSwap U False),
                                  ("M-S-<Down>", windowSwap D False),
                                  ("<Print>", spawn "flameshot gui"),
                                  ("M1-c", spawn "clipmenu -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'monospace-10'"),
                                  ("M-<F11>", spawn "amixer set Master 5%-"),
                                  ("M-<F12>", spawn "amixer set Master 5%+")
                                ]
              `removeKeysP` ["M-S-<Return>"]
              `removeKeysP` ["M-p"]
              `removeKeysP` ["M-S-c"]
              `removeKeysP` ["M-<Tab>"]
              `removeKeysP` ["M-S-<Tab>"]
              `removeKeysP` ["M-j"]
              `removeKeysP` ["M-k"]
              `removeKeysP` ["M-m"]
              `removeKeysP` ["M-l"]
        '';
    };
  };

  xdg.mime.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };

  environment = {
    # Don't forget to add the below to your system configuration to get completion for system packages (e.g. systemd).
    pathsToLink = [ "/share/zsh" ];
  };

  environment.variables = {
    EDITOR = "nvim";
    TERM = "wezterm";
    TERMINAL = "wezterm";
  };

  environment = {
    systemPackages = with pkgs; [
      # inputs.nixvim.packages.${system}.default
      # inputs.nixvim.packages.${system}.nvim
      # inputs.packages.${system}.nixvim
      # inputs.packages.${system}.default
      # inputs.nixvim.packages.${system}.nixvim
      # inputs.nixvim.packages.default
      # inputs.nixvim.packages.nvim
      # inputs.nixvim.packages.bla
      # inputs.nixvim.packages.x86_64-linux.default
      kbd
      neovide
      dmenu
      clipmenu
      nixd
      clang
      clang-tools
      cmake-language-server
      lua-language-server
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      taplo-lsp
      wget
      firefox
      google-chrome
      glib
      nnn
      bat
      eza
      wget
      go
      xclip
      notepadqq
      git
      kdiff3
      bitwarden
      bitwarden-cli
      alacritty
      dracula-theme
      gnumake
      cmake
      tree-sitter
      nodejs
      zip
      unzip
      openssh
      shutter
      flameshot
      signal-desktop
      kbdd
      xorg.setxkbmap
      glow
      jq
      nvd
      pandoc
      gcc
      python3
      pkg-config
      htop
      ripgrep
      coreutils
      fd
      networkmanagerapplet
      gdb
      lm_sensors
      python310Packages.psutil
      xorg.xmessage
      haskellPackages.cabal-fmt
      cabal-install
      haskellPackages.fourmolu
      ghcid
      gmp
      ncurses
      xz
      graphviz
      xdotool
      # polybarFull
      killall
      nitrogen
      nix-index
      acpi
      wally-cli
      asciidoctor-with-extensions
      rPackages.revealjs
      xvkbd
      gitui
      lazygit
      ruby
      nodePackages.prettier
      gimp
      tig
      marksman
      zk
      pkgs.man-pages
      pkgs.man-pages-posix
      xorg.xdpyinfo
      haskellPackages.hoogle
      proselint
      aspell
      aspellDicts.en
      aspellDicts.he
      languagetool
      silver-searcher
      nil
      pciutils
      steam-run
      nixpkgs-fmt
      microcodeIntel
      lshw
      openra
      transmission_4
      transmission_4-gtk
      vlc
      imagemagick
      bc
      baobab
      python310Packages.adblock
      python311Packages.adblock
      keyutils
      rofi
      doublecmd
      shotcut
      usbutils
      discord
      prismlauncher
      dysk
      rclone
      netflix
      iw
      usbutils
      udiskie
      udisks
      udisks2
      alsa-utils
      popcorntime
      trayer
      nawk
      lxappearance
      git-extras
      nixfmt-rfc-style
      ghc
      speedtest-cli
      numlockx
      # (writeShellApplication {
      #   name = "before.sh";
      #   text = # bash
      #     ''
      #       echo ---------------Running the before script------------------
      #       echo "Tangling ~/repos/dotfiles/configuration.org"
      #       nvim ~/repos/dotfiles/configuration.org --headless -c ':lua require("orgmode").action("org_mappings.org_babel_tangle")' +qa
      #       echo ""
      #       echo "Copying configuration.nix to /etc/nixos/configuration.nix"
      #       sudo cp ~/repos/dotfiles/configuration.nix /etc/nixos/configuration.nix
      #       echo ---------------The end------------------------------------
      #     '';
      # })
      (writeShellApplication {
        name = "git.sh";
        text = # bash
          ''
            echo ---------------Running the after script------------------
            git -C ~/repos/dotfiles add . && git -C ~/repos/dotfiles commit -m "WIP" && git -C ~/repos/dotfiles push
            echo ---------------The end------------------------------------
          '';
      })
      (writeShellApplication {
        name = "update.sh";
        text = # bash
          ''
            git.sh
            nix flake update
            sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --option eval-cache false
            cabal update
            git.sh
          '';
      })
      (writeShellApplication {
        name = "supdate.sh";
        text = # bash
          ''
            git.sh
            # For debug
            # sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --show-trace --print-build-logs --verbose --option eval-cache false
            sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --option eval-cache false
            git.sh
          '';
      })
      (writeShellApplication {
        name = "free.sh";
        text = # bash
          ''
            sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
            sudo nix-collect-garbage --delete-old
            nix-collect-garbage --delete-old
          '';
      })
      # (writeShellScriptBin "supdate-custom-home-manager.sh" ''  
      #   before.sh
      #   sudo -i nixos-rebuild switch -I home-manager=/home/refaelsh/repos/home-manager
      #   after.sh
      # '')
    ];
  };

  programs = {
    zsh.enable = true;
    nm-applet.enable = true;
    dconf.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

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

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users.refaelsh = import ./home.nix;
  };

}

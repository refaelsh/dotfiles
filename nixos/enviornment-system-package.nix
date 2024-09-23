{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
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
      man-pages
      man-pages-posix
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
      zoom-us
      (writeShellApplication {
        name = "git.sh";
        text = # bash
          ''
            echo ----------------------------Running Git---------------------------------
            git -C ~/repos/dotfiles add . && git -C ~/repos/dotfiles commit -m "WIP" && git -C ~/repos/dotfiles push
            echo ----------------------------Finished running Git---------------------------------
          '';
      })
      (writeShellApplication {
        name = "update.sh";
        text = # bash
          ''
            git.sh || true
            nix flake update ~/repos/dotfiles
            sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --option eval-cache false
            cabal update
            git.sh
          '';
      })
      (writeShellApplication {
        name = "supdate.sh";
        text = # bash
          ''
            git.sh || true
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
    ];
  };
}

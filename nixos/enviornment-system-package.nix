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
      google-chrome
      glib
      nnn
      wget
      go
      xclip
      notepadqq
      git
      kdiff3
      bitwarden
      # bitwarden-cli
      alacritty
      dracula-theme
      gnumake
      cmake
      tree-sitter
      nodejs
      zip
      unzip
      openssh
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
      python3Packages.psutil
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
      transmission_4
      transmission_4-gtk
      vlc
      imagemagick
      bc
      baobab
      python3Packages.adblock
      keyutils
      rofi
      doublecmd
      usbutils
      # discord
      prismlauncher
      dysk
      rclone
      # netflix
      iw
      usbutils
      udiskie
      udisks
      udisks2
      alsa-utils
      # popcorntime
      trayer
      # nawk
      lxappearance
      git-extras
      nixfmt-rfc-style
      ghc
      speedtest-cli
      numlockx
      zoom-us
      brave
      # qemu
      # android-studio
      marksman
      p7zip
      # zulu
      exiftool
      # keepass
      # bottles
      # lutris
      file
      shotcut
      (st.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
        patches = [
          # ligatures patch
          (fetchpatch {
            url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-20200430-0.8.3.diff";
            sha256 = "67b668c77677bfcaff42031e2656ce9cf173275e1dfd6f72587e8e8726298f09";
          })
        ];
        configFile = pkgs.writeText "config.def.h" (builtins.readFile ./st-config.h);
        postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      }))
    ];
  };
}

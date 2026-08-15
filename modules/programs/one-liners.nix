{ inputs, ... }:

{
  # Simple dendritic feature — just plain packages (no wrappers)
  flake.nixosModules.one-liners =
    { pkgs, ... }:
    {
      programs = {
        # zsh.enable = true;
        nm-applet.enable = true;
        dconf.enable = true;
        gamemode.enable = true;
        # bat.enable = true;

        # Rich tab completion framework + many built-in completions for bash.
        # Complements the readline settings we activate inside bash init.
        bash.completion.enable = true;

        # Provides command-not-found hook that suggests packages from nixpkgs
        # when an unknown command is typed (common behavior in Zsh Nix setups).
        nix-index.enable = true;
      };
      environment.systemPackages = with pkgs; [
        kbd
        neovide
        dmenu
        clipmenu
        nixd
        clang
        clang-tools
        cmake-language-server
        lua-language-server
        yaml-language-server
        bash-language-server
        taplo
        # Assembler toolchain for learning (GAS comes with binutils/gcc already).
        # nasm: Intel-syntax assembler commonly used in tutorials
        # asm-lsp: also pulled in by nixvim's asm_lsp server package; listing it
        # here keeps the binary available outside Neovim (e.g. gen-config).
        nasm
        asm-lsp
        wget
        google-chrome
        glib
        nnn
        go
        xclip
        kdiff3
        alacritty
        # dracula-theme
        gnumake
        cmake
        tree-sitter
        nodejs
        zip
        unzip
        # SSH client (scp/sftp/ssh). Not the sshd server; that stays off.
        # NixOS does not put these on PATH unless the package is listed.
        openssh
        signal-desktop
        kbdd
        setxkbmap
        glow
        jq
        nvd
        pandoc
        gcc
        python3
        pkg-config
        htop
        ripgrep
        fd
        atuin
        comma
        gdb
        lm_sensors
        python3Packages.psutil
        xmessage
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
        acpi
        wally-cli
        asciidoctor-with-extensions
        rPackages.revealjs
        xvkbd
        gitui
        lazygit
        ruby
        prettier
        gimp
        tig
        zk
        man-pages
        man-pages-posix
        xdpyinfo
        haskellPackages.hoogle
        proselint
        aspell
        aspellDicts.en
        aspellDicts.he
        languagetool
        pciutils
        smartmontools
        nvme-cli
        steam-run
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
        prismlauncher
        dysk
        rclone
        # netflix
        iw
        alsa-utils
        # popcorntime
        trayer
        # nawk
        lxappearance
        git-extras
        nixfmt
        ghc
        speedtest-cli
        numlockx
        zoom-us
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
        cachix
        fuzzel
        # discord
        nyxt
        emacs
        sbcl
        proton-pass
        # notepadqq
        # widelands
        beancount
        fava
        android-tools
        gh
      ];
    };
}

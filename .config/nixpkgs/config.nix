with (import <nixos-stable> {});
with (import <nixos-unstable> {});
with import <nixos-unstable/lib>;

let
  # localpkgs = import ~/projects/nixpkgs/default.nix {};
  unstable  = import <nixos-unstable/nixos> {};
  stable  = import <nixos-stable/nixos> {};
in {
  # permittedInsecurePackages = [
  #   "openssl-1.0.2u"
  #   "adobe-reader-9.5.5-1"
  # ];
  allowUnfree = true;
  oraclejdk.accept_license = true;
  android_sdk.accept_license = true;

  # Install local packages with localpkgs.X,
  # e.g.: localpkgs.xcwd

  # Install a package collection with:
  # nix-env -iA common-packages -f "<nixos-unstable>"
  # Uninstall all packages with
  # nix-env -e common-packages
  packageOverrides = pkgs: rec {

    inherit pkgs;

    vscode-liveshare = pkgs.vscode-with-extensions.override { vscodeExtensions = [ pkgs.vscode-extensions.ms-vsliveshare.vsliveshare ]; };

    common-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "common-packages";

      paths = [
        # Linux tools
        acpi
        avahi atop iotop
        bc calc
        binutils
        cryptsetup
        linuxPackages.cpupower
        dmidecode
        psmisc
        hdparm hd-idle hddtemp
        # openssl
        lm_sensors
        gnumake gcc clang
        pwgen
        btrfs-progs
        dbus-map
        lsof
        #mosh
        pciutils
        pv
        screen
        scrot
        tmux
        tmate
        nvme-cli
        unzip

        # nix-tools
        nix-index
        nix-prefetch-git
        nox
        patchelf

        # Network
        bind
        wget
        netcat
        nmap
        miniserve
        magic-wormhole
        ngrok
        nload nethogs
        speedtest-cli
        traceroute mtr
        inetutils
        wireshark
        networkmanagerapplet
        networkmanager_dmenu

        # Filesystem
        ncdu du-dust
        duf # du alternative
        sd # sed alternative
        fzf fasd file silver-searcher
        fuse-common
        autossh sshfs-fuse
        direnv
        lsyncd
        bindfs
        bat # cat alternative
        pmount
        tree
        gparted
        # broot
        ntfs3g
        inotify-tools
        smartmontools
        exfat
        gptfdisk
        usbutils
        ripgrep

        neovim coursier # coursier needed for neovim plugins
        python37Packages.pynvim
      ];

    };

    browser-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "browser-packages";

      paths = [
        # browser
        # tor-browser-bundle-bin # -> cannot be build
        firefox-bin #profile-sync-daemon
        # librewolf firefox profile-sync-daemon
        brave
        # (chromium.override { enableWideVine = false; })
        # chromium

        thunderbird-bin
      ];
    };

    desktop-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "desktop-packages";

      paths = [
        # Linux tools
        arandr
        rofi rofi-systemd #dmenu

        # x-server
        xcwd
        xclip
        autocutsel
        xdotool
        xorg.xdpyinfo xorg.xev xorg.xmodmap xorg.xkill xorg.xwininfo xorg.xhost
        vanilla-dmz # x cursor

        # Security
        # gnome3.gnome-keyring gnome3.libgnome-keyring gnome3.seahorse libsecret
        # keepass
        keepassxc

        # Terminal
        # alacritty
        rxvt-unicode #nix-zsh-completions
        tldr

        # Filesystem
        # gnome3.file-roller # mimeinfo collides with nautilus
        # shared-mime-info
        # desktop-file-utils

        # desktop
        #deadd-notification-center
        dunst
        networkmanagerapplet
        networkmanager_dmenu
        pcmanfm

        # Themes
        # tango-icon-theme
        # numix-gtk-theme
        # font-awesome
        # dconf

        # Fonts
      ];
    };

    apps-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "apps-packages";

      paths = [
        whatsapp-for-linux
        spotify
        zoom-us
        signal-desktop
        _1password-gui
        slack
      ];
    };

    media-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "media-packages";

      paths = [
        #ncmpcpp
        blueman
        mpv
        # pamixer
        pavucontrol
        playerctl
        # gnome3.cheese
        # ffmpeg-full
        # audacity
        # (ffmpeg-full.override { nonfreeLicensing = true;})
        # fwupd # bios + firmware updates
        # peek # record gif videos || green-recorder / gifcurry / screenToGif
        # qtox
        # shotwell
        # tesseract # open source ocr engine
        # vlc
        # vokoscreen # keymon -> abandoned
        veracrypt

        #TODO: desktop
        xdg_utils #?
        feh imv nitrogen

        #TODO office 
        # mate.atril
        # gimp
        # inkscape
        # evince
        # imagemagick7
      ];
    };

    office-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "office-packages";

      paths = [
        # Office
        # exif
        #libreoffice-still hunspell hunspellDicts.en-us hunspellDicts.de-de languagetool mythes
        gcolor3
        # qrencode
        #qsyncthingtray
        #simple-scan
        # typora # breaks on 2020-07-08
        #zathura
        # texlive.combined.scheme-full
        # texmaker #breaks on 2019-10-22
        # texstudio #lyx
        # pdftk #pdfshuffler
        # pdfsandwich pdfsam-basic pdfarranger
        #poppler_utils
        xournal
      ];
    };

    dev-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "dev-packages";

      paths = [
        #scala-packages
        scala
        #gdb
        git tig hub #gitRepo
        meld
        #difftastic
        jq

        # purescript
        # nodePackages.purescript-language-server

        #cmakeCurses
        # docker-compose
        entr
        #graphviz
        #gthumb
        #filezilla
        jetbrains.idea-community
        nodejs

        #vscode-liveshare
        scite

        ammonite
        sbt
        scala
        #visualvm

        kafkacat
      ];

    };

    laptop-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "laptop-packages";

      paths = [
        # libqmi
        #brillo # control keyboard led
        #cbatticon
        # light
        #linuxPackages.tp_smapi
        #linuxPackages.acpi_call
        #tlp
      ];

    };

    gaming-packages = buildEnv {

      inherit (unstable.config.system.path) pathsToLink ignoreCollisions postBuild;
      extraOutputsToInstall = [ "man" ];
      name = "gaming-packages";

      paths = [
        # steam
        # TODO shadow, currently in /etc/nixos/shadow.nix
      ];

    };
  };
}


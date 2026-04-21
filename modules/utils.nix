{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    lists
    mkBoolOption
    mkDisableOption
    mkIf
    ;
  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.utils;

  ripgrep_config = "ripgrep/ripgreprc";
  wgetrc = "wgetrc";
in {
  options.chonkos.utils = {
    enable = mkDisableOption "enable utils";

    desktopInstall = mkBoolOption "install utils for desktop" isDesktop;
  };

  config = mkIf cfg.enable {
    chonkos.unfree.allowed =
      [
        "drawio"
      ]
      ++ (lists.optionals cfg.desktopInstall [
        "discord"
      ]);

    environment.systemPackages = with pkgs; let
      # Overrides to avoid duplication
      ffmpeg =
        if cfg.desktopInstall
        then ffmpeg-full
        else ffmpeg-headless;
      # This would normally use another ffmpeg. This is to avoid duplication.
      czkawka-full = pkgs.czkawka-full.override {extraPackages = [ffmpeg];};
      fastfetch =
        if cfg.desktopInstall
        then pkgs.fastfetch
        else fastfetchMinimal;
      fortune = pkgs.fortune.override {withOffensive = true;};
    in
      [
        asciinema
        compose2nix
        cowsay
        curl
        dig
        doggo
        dos2unix
        dust
        fastfetch
        fd
        ffmpeg
        file
        fortune
        fzf
        gdu
        htop
        hyperfine
        iperf3
        jq
        just
        killall
        libxml2
        magic-wormhole
        man
        man-db
        man-pages
        man-pages-posix
        mc-monitor
        mcrcon
        moreutils
        prettier
        oha
        opustags
        p7zip
        packwiz
        ripgrep
        rsync
        simple-http-server
        socat
        speedtest-rs
        sqlite
        strace
        tealdeer
        time
        traceroute
        tree
        typos
        unrar-free
        unzip
        vimv-rs
        watch
        wget
        xxd
        zip
        zstd

        # Hardware
        btrfs-progs
        dmidecode
        dosfstools
        ethtool
        exfatprogs
        ntfs3g
        powertop
        smartmontools
        usbutils
        util-linux
        zfs
      ]
      ++ lists.optionals (config.nixpkgs.hostPlatform.system == "x86_64-linux") [
        # Hardware
        cpufrequtils
      ]
      ++ lists.optionals cfg.desktopInstall [
        anki
        appimage-run
        blender
        calibre # For ebook-convert
        czkawka-full
        discord
        drawio
        ferdium
        gimp
        gparted
        graphviz
        handbrake
        helium
        imagemagickBig
        libqalculate
        libreoffice-fresh
        localsend
        losslesscut-bin
        mcman
        nbt-explorer
        obs-studio
        onlyoffice-desktopeditors
        pandoc
        playerctl
        python3.pkgs.grip
        restic
        rust-stakeholder
        scrcpy
        thunar
        thunderbird
        ungoogled-chromium
        what-anime-cli
        xdg-ninja
        zen-browser
      ];

    environment.shellAliases = {
      opusedit = "opustags --edit --in-place";
    };

    home-manager.sharedModules = [
      (homeInputs: let
        homeConfig = homeInputs.config;
      in {
        programs.btop = {
          enable = true;
          settings = {
            vim_keys = true;
          };
        };

        programs.fzf.enable = true;

        home.sessionVariables = {
          RIPGREP_CONFIG_PATH = "${homeConfig.xdg.configHome}/" + ripgrep_config;
          WGETRC = "${homeConfig.xdg.configHome}/" + wgetrc;
        };

        xdg.configFile = {
          ${ripgrep_config}.text = "";
          ${wgetrc}.text = ''
            hsts-file = ${homeConfig.xdg.cacheHome}/wget-hsts
          '';
        };
      })
    ];
  };
}

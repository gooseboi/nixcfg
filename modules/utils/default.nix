{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) lists mkEnableOption mkIf;
  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.utils;

  ripgrep_config = "ripgrep/ripgreprc";
  wgetrc = "wgetrc";
in {
  options.chonkos.utils = {
    enable = mkEnableOption "enable utils";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; let
      # Custom packages
      mc-monitor = callPackage ./mc-monitor.nix {};
      rust-stakeholder = callPackage ./rust-stakeholder.nix {};
      what-anime-cli = callPackage ./what-anime.nix {};

      # Overrides to avoid duplication
      ffmpeg =
        if isDesktop
        then ffmpeg-full
        else ffmpeg-headless;
      # This would normally use another ffmpeg. This is to avoid duplication.
      czkawka-full = pkgs.czkawka-full.override {extraPackages = [ffmpeg];};
      fastfetch =
        if isDesktop
        then pkgs.fastfetch
        else fastfetchMinimal;
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
        fzf
        gdu
        htop
        hyperfine
        iperf3
        jq
        just
        killall
        libqalculate
        libxml2
        magic-wormhole
        man
        man-db
        man-pages
        man-pages-posix
        mc-monitor
        mcrcon
        moreutils
        nh
        nix-tree
        nodePackages.prettier
        oha
        opustags
        p7zip
        packwiz
        pandoc
        python3.pkgs.grip
        ripgrep
        rsync
        rust-stakeholder
        simple-http-server
        socat
        speedtest-rs
        sqlite
        strace
        tealdeer
        time
        traceroute
        tree
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
      ++ lists.optionals isDesktop [
        czkawka-full
        imagemagickBig
        localsend
        what-anime-cli
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

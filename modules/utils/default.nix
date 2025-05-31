{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.utils;

  ripgrep_config = "ripgrep/ripgreprc";
  wgetrc = "wgetrc";
in {
  options.chonkos.utils = {
    enable = lib.mkEnableOption "enable utils";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; let
      # Custom packages
      mc-monitor = callPackage ./mc-monitor.nix {};
      rust-stakeholder = callPackage ./rust-stakeholder.nix {};

      # Overrides to avoid duplication
      ffmpeg-full = pkgs.ffmpeg-full.override {
        # ffmpeg only uses sdl2 to show stuff on screen or play audio, ('Real
        # Time Playback/Display' according to chat gpt). You only do this on a
        # desktop, so we disable it on servers. The reason for doing this is
        # that Sdl2 takes gtk3 as a dep, and we don't want this on a server,
        # because it it unnecessary and also wastes space.
        withSdl2 = isDesktop;

        # Apparently, to compile ffmpeg, you need opencv, and to compile
        # opencv, you need ffmpeg. Very nice. Opencv depends on the normal
        # ffmpeg, so we disable that one's sdl2 support.
        #
        # This builds ffmpeg twice, one for the full and another for the opencv
        # one. This is unavoidable, as otherwise you'd get an infinite
        # recursion, using ffmpeg-full to build ffmpeg-full. I can wait the
        # 30mins when ffmpeg is updated.
        frei0r = pkgs.frei0r.override {
          opencv = pkgs.opencv.override {
            ffmpeg = pkgs.ffmpeg.override {withSdl2 = isDesktop;};
          };
        };
      };
      # This would normally use another ffmpeg. This is to avoid duplication.
      czkawka-full = pkgs.czkawka-full.override {extraPackages = [ffmpeg-full];};
      fastfetch = pkgs.fastfetch.override {
        x11Support = isDesktop;
        waylandSupport = isDesktop;
      };
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
        ffmpeg-full
        file
        fzf
        gdu
        htop
        hyperfine
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
        p7zip
        pandoc
        ripgrep
        rsync
        rust-stakeholder
        simple-http-server
        socat
        speedtest-rs
        strace
        tealdeer
        time
        traceroute
        tree
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
      ++ lib.lists.optionals (config.nixpkgs.hostPlatform.system == "x86_64-linux") [
        # Hardware
        cpufrequtils
      ]
      ++ lib.lists.optionals isDesktop [
        czkawka-full
      ];

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

{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.utils;

  ripgrep_config = "ripgrep/ripgreprc";
  wgetrc = "wgetrc";
in {
  options.chonkos.utils = {
    enable = lib.mkEnableOption "enable utils";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; let
      mc-monitor = callPackage ./mc-monitor.nix {};
      rust-stakeholder = callPackage ./rust-stakeholder.nix {};
      czkawka-full = pkgs.czkawka-full.override {extraPackages = [ffmpeg-full];};
    in [
      asciinema
      compose2nix
      cowsay
      curl
      czkawka-full
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
      cpufrequtils
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
    ];

    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };

    programs.fzf.enable = true;

    home.sessionVariables = {
      RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/" + ripgrep_config;
      WGETRC = "${config.xdg.configHome}/" + wgetrc;
    };

    xdg.configFile = {
      ${ripgrep_config}.text = "";
      ${wgetrc}.text = ''
        hsts-file = ${config.xdg.cacheHome}/wget-hsts
      '';
    };
  };
}

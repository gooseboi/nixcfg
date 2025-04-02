{
  pkgs,
  lib,
  config,
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
    home.packages = with pkgs; [
      curl
      czkawka-full
      dig
      dust
      fd
      ffmpeg-full
      file
      fzf
      gdu
      htop
      hyperfine
      jq
      killall
      libqalculate
      magic-wormhole
      man
      man-db
      man-pages
      man-pages-posix
      moreutils
      nh
      nix-tree
      nodePackages.prettier
      oha
      p7zip
      ripgrep
      rsync
      socat
      speedtest-rs
      tealdeer
      tree
      unzip
      watch
      wget

      # Hardware
      btrfs-progs
      dosfstools
      ethtool
      exfatprogs
      ntfs3g
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

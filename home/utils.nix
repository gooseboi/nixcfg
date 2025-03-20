{
  pkgs,
  lib,
  config,
  mkMyLib,
  ...
}: let
  cfg = config.chonkos.utils;

  myLib = mkMyLib config;

  ripgrep_config = "ripgrep/ripgreprc";
  wgetrc = "wgetrc";
in {
  options.chonkos.utils = {
    enable = lib.mkEnableOption "enable utils";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      btrfs-progs
      curl
      dig
      dosfstools
      dust
      exfatprogs
      fd
      ffmpeg-full
      file
      fzf
      gdu
      htop
      hyperfine
      killall
      libqalculate
      magic-wormhole
      man
      man-db
      man-pages
      man-pages-posix
      moreutils
      nh
      ntfs3g
      oha
      p7zip
      ripgrep
      socat
      tealdeer
      tree
      unzip
      watch
      wget
    ];

    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };

    home.sessionVariables = {
      RIPGREP_CONFIG_PATH = config.xdg.configHome + ripgrep_config;
      WGETRC = config.xdg.configHome + wgetrc;
    };

    xdg.configFile = {
      ${ripgrep_config}.text = "";
      ${wgetrc}.text = ''
        hsts-file = ${config.xdg.cacheHome}/wget-hsts
      '';
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.chonkos.utils;

  stringToPath = prefix: pathStr: prefix + builtins.toPath pathStr;
  absoluteStringToPath = pathStr: stringToPath /. pathStr;
  removeHomeDirPrefix = path: lib.path.removePrefix (absoluteStringToPath config.home.homeDirectory) path;
  removeHomeDirPrefixStr = path: removeHomeDirPrefix (absoluteStringToPath path);

  inherit (config.xdg) configHome;

  ripgrep_config = "${configHome}/ripgrep/ripgreprc";
  wgetrc = "${configHome}/wgetrc";
in {
  options.chonkos.utils = {
    enable = lib.mkEnableOption "enable utils";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # Utils
        gdu
        btop
        btrfs-progs
        curl
        dosfstools
        dust
        exfatprogs
        fd
        ffmpeg-full
        file
        fzf
        htop
        killall
        libqalculate
        magic-wormhole
        man
        man-db
        man-pages
        man-pages-posix
        moreutils
        ntfs3g
        p7zip
        ripgrep
        socat
        tealdeer
        tree
        unzip
        wget

        # Nix utils
        nh
      ];

      sessionVariables = {
        RIPGREP_CONFIG_PATH = ripgrep_config;
        WGETRC = wgetrc;
      };

      file = {
        "${removeHomeDirPrefixStr ripgrep_config}".text = "";
        "${removeHomeDirPrefixStr wgetrc}".text = ''
          hsts-file = ${config.xdg.cacheHome}/wget-hsts
        '';
      };
    };
  };
}

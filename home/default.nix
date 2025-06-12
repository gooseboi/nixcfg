{
  config,
  lib,
  ...
}: let
  inherit (lib) listNixWithDirs remove;

  cfg = config.chonkos;
in {
  imports = listNixWithDirs ./. |> remove ./default.nix;

  options.chonkos = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };
  };

  config = {
    home = {
      username = cfg.user;
      homeDirectory = "/home/${cfg.user}";
      shellAliases = {
        # Common
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -vI";
        mkd = "mkdir -pv";
        yt = "youtube-dl -f best -ic --add-metadata";
        yta = "youtube-dl -f best -icx --add-metadata";
        ytp = "yt-dlp --download-archive ~/.config/yt/yt-dl-vid.conf";
        ytap = "yt-dlp -icx --add-metadata";
        ffmpeg = "ffmpeg -hide_banner";
        xclipboard = "xclip -selection clipboard";

        # Colour
        grep = "grep --color=auto";
        diff = "diff --color=auto";
      };
    };
    xdg.enable = true;

    home.sessionVariables =
      # Default Apps
      {
        COLORTERM = "truecolor";
        OPENER = "xdg-open";
      }
      //
      # Fixing paths
      {
        ANDROID_HOME = "${config.xdg.dataHome}/android";
        DOCKER_CONFIG = "${config.xdg.configHome}/docker";
        DOT_SAGE = "${config.xdg.configHome}/sage";
        ELECTRUMDIR = "${config.xdg.dataHome}/electrum";
        GNUPGHOME = "${config.xdg.dataHome}/gnupg";
        GRIPHOME = "${config.xdg.configHome}/grip";
        GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
        MAXIMA_USERDIR = "${config.xdg.configHome}/maxima";
        SQLITE_HISTORY = "${config.xdg.cacheHome}/sqlite_history";
        STACK_ROOT = "${config.xdg.dataHome}/stack";
        TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
        WINEPREFIX = "${config.xdg.dataHome}/wine";
      };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) listNixWithDirs mkOption remove types;

  cfg = config.chonkos;
in {
  imports = listNixWithDirs ./. |> remove ./default.nix;

  options.chonkos = {
    user = mkOption {
      type = types.str;
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
        cp = "cp --interactive --verbose";
        mv = "mv --interactive --verbose";
        rm = "rm --verbose --interactive=once";
        mkd = "mkdir --parents --verbose";
        ytp = "yt-dlp --download-archive ~/.config/yt/yt-dl-vid.conf";
        ytap = "yt-dlp --ignore-errors --continue --extract-audio --add-metadata";
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

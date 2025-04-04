{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos;
in {
  imports =
    [
      ./alacritty.nix
      ./dev.nix
      ./eza.nix
      ./fonts.nix
      ./git.nix
      ./jujutsu.nix
      ./rofi.nix
      ./tmux.nix
      ./utils.nix
      ./zathura.nix
      ./zsh.nix
    ]
    ++ [
      ./desktop
      ./hyprland
      ./nvim
      ./scripts
    ];

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
    };
    xdg.enable = true;

    home.sessionVariables =
      # Default Apps
      {
        COLORTERM = "truecolor";
        OPENER = "xdg-open";
        PAGER = "less";
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
  };
}

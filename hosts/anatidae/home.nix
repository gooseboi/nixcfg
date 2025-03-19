{
  config,
  pkgs,
  ...
}: {
  chonkos = {
    user = "chonk";

    hyprland.enable = true;
    alacritty.enable = true;
    eza.enable = true;
    zsh = {
      enable = true;
      enableVimMode = true;
      enableFzfIntegration = true;
    };
    tmux = {
      enable = true;
      enableSessionizer = true;
    };
    nvim.enable = true;
    zathura.enable = true;
    jujutsu.enable = true;
    scripts.enable = true;
    fonts.enable = true;
    rofi.enable = true;
    utils.enable = true;
    dev.enable = true;
  };

  home = {
    stateVersion = "24.11";

    packages = with pkgs; [
      # Typesetting
      texliveFull
      typst
    ];

    sessionVariables =
      # Default Apps
      {
        BROWSER = "librewolf";
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

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

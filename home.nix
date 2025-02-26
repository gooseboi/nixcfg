{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home
  ];

  chonkos = {
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
  };

  home = {
    username = "chonk";
    homeDirectory = "/home/chonk";

    stateVersion = "24.11";

    packages = with pkgs; [
      # Dev
      odin
      python3
      zig

      # Typesetting
      texliveFull
      typst
    ];

    sessionVariables =
      # Default Apps
      {
        EDITOR = "nvim";
        VISUAL = "nvim";
        TERMINAL = "alacritty";
        BROWSER = "librewolf";
        VIDEO = "mpv";
        COLORTERM = "truecolor";
        OPENER = "xdg-open";
        PAGER = "less";
      }
      //
      # Fixing paths
      {
        ANDROID_HOME = "${config.xdg.dataHome}/android";
        CABAL_CONFIG = "${config.xdg.configHome}/cabal/config";
        CABAL_DIR = "${config.xdg.dataHome}/cabal";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        DOCKER_CONFIG = "${config.xdg.configHome}/docker";
        DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
        DOT_SAGE = "${config.xdg.configHome}/sage";
        ELAN_HOME = "${config.xdg.dataHome}/elan";
        ELECTRUMDIR = "${config.xdg.dataHome}/electrum";
        GEM_PATH = "${config.xdg.dataHome}/ruby/gems";
        GEM_SPEC_CACHE = "${config.xdg.dataHome}/ruby/specs";
        GHCUP_USE_XDG_DIRS = "true";
        GNUPGHOME = "${config.xdg.dataHome}/gnupg";
        GOPATH = "${config.xdg.dataHome}/go";
        GRIPHOME = "${config.xdg.configHome}/grip";
        GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
        LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
        MAXIMA_USERDIR = "${config.xdg.configHome}/maxima";
        NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        NUGET_PACKAGES = "${config.xdg.cacheHome}/nuget";
        OPAMROOT = "${config.xdg.dataHome}/opam";
        PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        SQLITE_HISTORY = "${config.xdg.cacheHome}/sqlite_history";
        STACK_ROOT = "${config.xdg.dataHome}/stack";
        TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
        VAGRANT_HOME = "${config.xdg.dataHome}/vagrant";
        WINEPREFIX = "${config.xdg.dataHome}/wine";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=on";
      }
      //
      # Scaling
      {
        QT_AUTO_SCREEN_SCALE_FACTOR = 0;
        QT_SCALE_FACTOR = 1;
        QT_SCREEN_SCALE_FACTORS = "1;1;1";
        GDK_SCALE = 1;
        GDK_DPI_SCALE = 1;
      };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home
  ];

  chonkos = {
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
    zathura.enable = true;
  };

  home = {
    username = "chonk";
    homeDirectory = "/home/chonk";

    stateVersion = "24.11";

    packages = with pkgs;
      [
        # Utils
        btop
        btrfs-progs
        dosfstools
        dust
        exfatprogs
        fd
        ffmpeg-full
        fzf
        htop
        libqalculate
        man
        man-db
        man-pages
        man-pages-posix
        ntfs3g
        p7zip
        socat
        tealdeer
        unzip

        # Dev
        odin
        python3
        zig

        # Typesetting
        texliveFull
        typst

        # Fonts
        libertinus
        noto-fonts
        noto-fonts-color-emoji
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues nerd-fonts);

    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

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
        RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/rip/ripgreprc";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        SQLITE_HISTORY = "${config.xdg.cacheHome}/sqlite_history";
        STACK_ROOT = "${config.xdg.dataHome}/stack";
        TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
        VAGRANT_HOME = "${config.xdg.dataHome}/vagrant";
        WGETRC = "${config.xdg.configHome}/wgetrc";
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

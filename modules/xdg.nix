{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkIf
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.xdg;
in {
  options.chonkos.xdg = {
    enable = mkBoolOption "enable polkit installation" isDesktop;
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      (homeArgs: let
        homeConfig = homeArgs.config;

        inherit
          (homeConfig.xdg)
          cacheHome
          configHome
          dataHome
          ;

        inherit
          (homeConfig.home)
          homeDirectory
          ;
      in {
        home = {
          sessionVariables = {
            ANDROID_HOME = "${dataHome}/android";
            DOCKER_CONFIG = "${configHome}/docker";
            DOT_SAGE = "${configHome}/sage";
            ELECTRUMDIR = "${dataHome}/electrum";
            GNUPGHOME = "${dataHome}/gnupg";
            GRIPHOME = "${configHome}/grip";
            LESSHISTFILE = "${cacheHome}/less/history";
            MAXIMA_USERDIR = "${configHome}/maxima";
            SQLITE_HISTORY = "${cacheHome}/sqlite_history";
            STACK_ROOT = "${dataHome}/stack";
            TEXMFVAR = "${cacheHome}/texlive/texmf-var";
            WINEPREFIX = "${dataHome}/wine";

            OPENER = "xdg-open";
          };

          shellAliases = {
            open = "xdg-open";
          };

          preferXdgDirectories = true;
        };

        xdg = {
          enable = true;

          mime.enable = true;
          mimeApps = {
            enable = true;
            defaultApplications = {
              "application/json" = ["nvim.desktop"];
              "application/pdf" = ["org.pwmt.zathura.desktop"];
              "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = ["impress.desktop" "org.onlyoffice.desktopeditors.desktop"];
              "application/vnd.ms-powerpoint" = ["impress.desktop" "org.onlyoffice.desktopeditors.desktop"];
              "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["impress.desktop" "org.onlyoffice.desktopeditors.desktop"];
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop" "org.onlyoffice.desktopeditors.desktop"];
              "audio/mpeg" = ["mpv.desktop"];
              "image/bmp" = ["imv.desktop"];
              "image/gif" = ["imv.desktop"];
              "image/jpeg" = ["imv.desktop"];
              "image/png" = ["imv.desktop"];
              "image/svg+xml" = ["imv.desktop"];
              "image/webp" = ["imv.desktop"];
              "inode/directory" = ["Thunar.desktop"];
              "text/html" = ["librewolf.desktop"];
              "text/plain" = ["nvim.desktop"];
              "video/mp4" = ["mpv.desktop"];
              "video/quicktime" = ["mpv.desktop"];
              "video/x-matroska" = ["mpv.desktop"];
              "x-scheme-handler/ferdium" = ["ferdium.deskto"];
              "x-scheme-handler/http" = ["librewolf.desktop"];
              "x-scheme-handler/https" = ["librewolf.desktop"];
              "x-scheme-handler/mailto" = ["thunderbird.desktop"];
            };
          };

          userDirs = {
            enable = true;
            createDirectories = true;
            setSessionVariables = true;

            documents = "${homeDirectory}/dox";
            download = "${homeDirectory}/down";
            music = "${homeDirectory}/music";
            pictures = "${homeDirectory}/pix";
            projects = "${homeDirectory}/dev";
            videos = "${homeDirectory}/vids";

            desktop = null;
            publicShare = null;
            templates = null;
          };
        };
      })
    ];
  };
}

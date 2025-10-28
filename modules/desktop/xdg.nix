{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf;

  cfg = config.chonkos.desktop.xdg;
in {
  options.chonkos.desktop.xdg = {
    enable = mkOption {
      description = "enable polkit installation";
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      (homeArgs: let
        homeConfig = homeArgs.config;
      in {
        home.shellAliases = {
          open = "xdg-open";
        };

        xdg = {
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

            documents = "${homeConfig.home.homeDirectory}/dox";
            download = "${homeConfig.home.homeDirectory}/down";
            music = "${homeConfig.home.homeDirectory}/music";
            pictures = "${homeConfig.home.homeDirectory}/pix";
            videos = "${homeConfig.home.homeDirectory}/vids";

            desktop = null;
            publicShare = null;
            templates = null;
          };
        };
        home.preferXdgDirectories = true;
      })
    ];
  };
}

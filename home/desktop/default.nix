{
  config,
  lib,
  pkgs,
  systemConfig,
  ...
}: let
  cfg = config.chonkos.desktop;
in {
  options.chonkos.desktop = {
    enable = lib.mkEnableOption "enable desktop configurations";
  };

  imports = [
    ./firefox.nix
    ./newsboat.nix
    ./imv.nix
  ];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = systemConfig.chonkos.desktop.enable == true;
        message = ''
          This module doesn't work if the system desktop module is not enabled.
        '';
      }
    ];

    home = {
      sessionVariables =
        {
          VIDEO = "mpv";
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

      packages = with pkgs; [
        gimp
        libreoffice-fresh
        mpv
        onlyoffice-bin
        playerctl
        xfce.thunar
      ];
    };

    xdg = {
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/json" = ["nvim.desktop"];
          "application/pdf" = ["org.pwmt.zathura.desktop"];
          "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = ["org.onlyoffice.desktopeditors.desktop"];
          "application/vnd.ms-powerpoint" = ["org.onlyoffice.desktopeditors.desktop"];
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["org.onlyoffice.desktopeditors.desktop"];
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["org.onlyoffice.desktopeditors.desktop"];
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

        documents = "${config.home.homeDirectory}/dox";
        download = "${config.home.homeDirectory}/down";
        music = "${config.home.homeDirectory}/music";
        pictures = "${config.home.homeDirectory}/pix";
        videos = "${config.home.homeDirectory}/vids";

        desktop = null;
        publicShare = null;
        templates = null;
      };
    };
  };
}

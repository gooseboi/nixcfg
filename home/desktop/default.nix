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

    programs.imv = {
      enable = true;
      settings = {
        binds = {
          q = "quit";

          # Image navigation
          "<Left>" = "prev";
          "<Right>" = "next";
          "<Shift+K>" = "prev";
          "<Shift+J>" = "next";
          gg = "goto 1";
          "<Shift+G>" = "goto -1";

          # Panning
          j = "pan 0 -50";
          k = "pan 0 50";
          h = "pan 50 0";
          l = "pan -50 0";

          # Zooming
          "<Shift+plus>" = "zoom 1";
          "<minus>" = "zoom -1";
          "<Shift+I>" = "zoom 1";
          "<Shift+O>" = "zoom -1";

          # Rotate Clockwise by 90 degrees
          "<Ctrl+r>" = "rotate by 90";

          # Other commands
          f = "fullscreen";
          i = "overlay";
          p = "exec echo $imv_current_file";
          c = "center";
          s = "scaling next";
          "<Shift+S>" = "upscaling next";
          a = "zoom actual";
          r = "reset";

          # Gif playback
          "<period>" = "next_frame";
          "<space>" = "toggle_playing";

          # Slideshow control
          t = "slideshow +1";
          "<Shift+T>" = "slideshow -1";
        };
      };
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

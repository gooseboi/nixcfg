{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    ;

  inherit (config.chonkos) theme;

  cfg = config.chonkos.desktop.gtk;
in {
  options.chonkos.desktop.gtk = {
    enable = mkOption {
      description = "enable gtk config";
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      (homeArgs: let
        homeConfig = homeArgs.config;
      in {
        gtk = let
          commonConfig = {
            gtk-xft-antialias = 1;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintfull";
            gtk-xft-rgba = "rgb";
            gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
            gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
            gtk-button-images = 1;
            gtk-menu-images = 1;
          };
          commonConfigStr =
            commonConfig
            |> lib.attrsToList
            |> map ({
              name,
              value,
            }: "${name} = ${builtins.toString value}")
            |> lib.concatStringsSep "\n";
        in {
          enable = true;

          font = with theme.font; {
            name = sans.name;
            package = sans.package;
            size = size.normal;
          };

          iconTheme = {
            inherit (theme.icons) name package;
          };

          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };

          gtk2 = {
            configLocation = "${homeConfig.xdg.configHome}/gtk-2.0/gtkrc";
            extraConfig = ''
              gtk-enable-event-sounds = 1
              gtk-enable-input-feedback-sounds = 1

              ${commonConfigStr}
            '';
          };

          gtk3 = {
            bookmarks = [
              "file://${homeConfig.home.homeDirectory}/dev"
              "file://${homeConfig.home.homeDirectory}/pix/screenshots"
            ];

            extraConfig =
              {
                gtk-application-prefer-dark-theme = true;
                gtk-button-images = true;
                gtk-decoration-layout = "icon:minimize,maximize,close";
                gtk-enable-animations = true;
                gtk-menu-images = true;
                gtk-primary-button-warps-slider = false;
              }
              // commonConfig;
            extraCss =
              /*
              css
              */
              ''
                .deadd-noti-center {
                    font-family: Roboto;
                }

                image.deadd-noti-center.notification.image {
                  margin-left: 1em;
                  margin-bottom: 1em;
                  margin-top: 1em;
                }
              '';
          };
        };
      })
    ];
  };
}

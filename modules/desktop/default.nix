{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.chonkos) isDesktop;
  inherit
    (lib)
    listNixWithDirs
    mkIf
    mkOption
    remove
    types
    ;

  cfg = config.chonkos.desktop;
in {
  options.chonkos.desktop = {
    enable = mkOption {
      type = types.bool;
      description = "enable desktop configurations";
      default = isDesktop;
    };
  };

  imports = listNixWithDirs ./. |> remove ./default.nix;

  config = mkIf cfg.enable {
    chonkos.unfree.allowed = ["discord"];

    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      anki
      discord
      ferdium
      gimp
      gparted
      libreoffice-fresh
      mpv
      onlyoffice-bin
      playerctl
      ungoogled-chromium
      xfce.thunar
    ];

    home-manager.sharedModules = [
      {
        config = {
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
          };
        };
      }
    ];
  };
}

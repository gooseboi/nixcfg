{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) listNixWithDirs;

  cfg = config.chonkos.desktop;
in {
  options.chonkos.desktop = {
    enable = lib.mkEnableOption "enable desktop configurations";
  };

  imports = listNixWithDirs ./nixos;

  config = lib.mkIf cfg.enable {
    chonkos.unfree.allowed = ["discord"];

    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      discord
      ferdium
      gimp
      libreoffice-fresh
      mpv
      onlyoffice-bin
      playerctl
      xfce.thunar
    ];

    home-manager.sharedModules = [
      {
        imports = listNixWithDirs ./home;

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

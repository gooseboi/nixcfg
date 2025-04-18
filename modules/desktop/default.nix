{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.desktop;
in {
  options.chonkos.desktop = {
    enable = lib.mkEnableOption "enable desktop configurations";
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      discord
      gimp
      libreoffice-fresh
      mpv
      onlyoffice-bin
      playerctl
      whatsapp-for-linux
      xfce.thunar
    ];

    home-manager.sharedModules = [
      {
        imports = [
          ./firefox.nix
          ./gtk.nix
          ./imv.nix
          ./newsboat.nix
          ./xdg.nix
        ];

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

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
        imv
        xfce.thunar
        gimp
        libreoffice-fresh
        playerctl
      ];
    };
  };
}

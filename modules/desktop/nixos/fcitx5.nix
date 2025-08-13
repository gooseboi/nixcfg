{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  deskCfg = config.chonkos.desktop;
  cfg = deskCfg.fcitx5;
in {
  options.chonkos.desktop.fcitx5 = {
    enable = mkEnableOption "enable fcitx5 install";
  };

  config = mkIf (deskCfg.enable && cfg.enable) {
    home-manager.sharedModules = [
      {
        # For systemd user service
        i18n.inputMethod = {
          enable = true;

          type = "fcitx5";
          fcitx5 = {
            waylandFrontend = true;
            addons = with pkgs; [
              kdePackages.fcitx5-qt
              fcitx5-mozc
              fcitx5-gtk
            ];
          };
        };
      }
    ];
  };
}

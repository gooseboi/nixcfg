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
    types
    ;

  cfg = config.chonkos.desktop.fcitx5;
in {
  options.chonkos.desktop.fcitx5 = {
    enable = mkOption {
      description = "enable fcitx5 installation and config";
      type = types.bool;
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
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

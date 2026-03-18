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

            settings = {
              globalOptions = {
                "Hotkey/TriggerKeys" = {
                  "0" = "Control+semicolon";
                };
              };

              inputMethod = {
                GroupOrder."0" = "Default";

                "Groups/0" = {
                  Name = "Default";
                  "Default Layout" = "us";
                  DefaultIM = "mozc";
                };

                "Groups/0/Items/0" = {
                  Name = "keyboard-us";
                  Layout = "";
                };

                "Groups/0/Items/1" = {
                  Name = "mozc";
                  Layout = "";
                };
              };
            };
          };
        };
      }
    ];
  };
}

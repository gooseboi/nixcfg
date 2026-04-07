{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkIf
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.fcitx5;
in {
  options.chonkos.fcitx5 = {
    enable = mkBoolOption "enable fcitx5 installation and config" isDesktop;
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
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

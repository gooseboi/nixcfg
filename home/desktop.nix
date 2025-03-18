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

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = systemConfig.chonkos.desktop.enable == true;
        message = ''
          This module doesn't work if the system desktop module is not enabled.
        '';
      }
    ];

    home.packages = with pkgs; [
      imv
      xfce.thunar
      gimp
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf;

  cfg = config.chonkos.desktop.qmk;
in {
  options.chonkos.desktop.qmk = {
    enable = mkOption {
      description = "enable polkit installation";
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      qmk
    ];
  };
}

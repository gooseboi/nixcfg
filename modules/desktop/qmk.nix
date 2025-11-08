{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.chonkos.desktop.qmk;
in {
  options.chonkos.desktop.qmk = {
    enable = mkEnableOption "enable qmk installation";
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      qmk
    ];
  };
}

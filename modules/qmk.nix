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

  cfg = config.chonkos.qmk;
in {
  options.chonkos.qmk = {
    enable = mkBoolOption "enable qmk installation" isDesktop;
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      qmk
    ];
  };
}

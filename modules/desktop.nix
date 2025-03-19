{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.desktop;
in {
  options.chonkos.desktop = {
    enable = lib.mkEnableOption "enable desktop configs";
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
  };
}

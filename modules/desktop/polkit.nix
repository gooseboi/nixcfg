{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    ;

  cfg = config.chonkos.desktop.polkit;
in {
  options.chonkos.desktop.polkit = {
    enable = mkOption {
      description = "enable polkit installation";
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
  };
}

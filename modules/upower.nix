{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkIf
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.upower;
in {
  options.chonkos.upower = {
    enable = mkBoolOption "enable upower config" isDesktop;
  };

  config = mkIf cfg.enable {
    services.upower.enable = true;
  };
}

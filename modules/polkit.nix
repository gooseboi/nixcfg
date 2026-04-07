{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkBoolOption
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.polkit;
in {
  options.chonkos.polkit = {
    enable = mkBoolOption "enable polkit installation" isDesktop;
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
  };
}

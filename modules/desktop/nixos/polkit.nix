{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  deskCfg = config.chonkos.desktop;
in {
  config = mkIf (deskCfg.enable) {
    security.polkit.enable = true;
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.direnv;
in {
  options.chonkos.direnv = {
    enable = mkEnableOption "enable direnv";
  };

  config.programs.direnv = mkIf cfg.enable {
    enable = true;
  };
}

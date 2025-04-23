{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.direnv;
in {
  options.chonkos.direnv = {
    enable = lib.mkEnableOption "enable direnv";
  };

  config.programs.direnv = lib.mkIf cfg.enable {
    enable = true;
  };
}

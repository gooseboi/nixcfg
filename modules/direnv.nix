{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.chonkos.direnv;
in {
  options.chonkos.direnv = {
    enable = mkEnableOption "enable direnv";
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.direnv = {
          enable = true;
        };
      }
    ];
  };
}

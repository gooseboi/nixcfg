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

  cfg = config.chonkos.direnv;
in {
  options.chonkos.direnv = {
    enable = mkBoolOption "enable direnv" isDesktop;
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

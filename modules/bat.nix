{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkDisableOption
    mkIf
    ;

  cfg = config.chonkos.bat;
in {
  options.chonkos.bat = {
    enable = mkDisableOption "enable bat";
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        home.sessionVariables.PAGER = "bat";
        programs.bat.enable = true;
      }
    ];
  };
}

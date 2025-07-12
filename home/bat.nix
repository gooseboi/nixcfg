{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.bat;
in {
  options.chonkos.bat = {
    enable = mkEnableOption "enable bat";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.PAGER = "bat";
    programs.bat.enable = true;
  };
}

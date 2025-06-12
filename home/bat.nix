{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.bat;
in {
  options.chonkos.bat = {
    enable = lib.mkEnableOption "enable bat";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.PAGER = "bat";
    programs.bat.enable = true;
  };
}

{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.adb;
in {
  options.chonkos.adb = {
    enable = lib.mkEnableOption "enable adb support";
  };

  config = lib.mkIf cfg.enable {
    programs.adb.enable = true;

    users.users.${config.chonkos.user}.extraGroups = ["adbusers"];
  };
}

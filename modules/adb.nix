{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.adb;
in {
  options.chonkos.adb = {
    enable = mkEnableOption "enable adb support";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;

    users.users.${config.chonkos.user}.extraGroups = ["adbusers"];
  };
}

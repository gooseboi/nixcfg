{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos;
in {
  options.chonkos.network-manager = {
    enable = lib.mkEnableOption "enable network manager";
  };

  config = lib.mkIf cfg.network-manager.enable {
    networking.networkmanager.enable = true;

    users.users.${cfg.user}.extraGroups = ["networkmanager"];
  };
}

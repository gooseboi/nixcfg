{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.docker;
in {
  options.chonkos.docker = {
    enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;

        storageDriver = "btrfs";
      };
    };
    users.users.${config.chonkos.user}.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
      dive
    ];
  };
}

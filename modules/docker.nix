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
      docker = {
        enable = true;

        storageDriver = "btrfs";
      };
    };

    users.extraGroups.docker.members = [config.chonkos.user];

    environment.shellAliases.docc = "docker compose";

    environment.systemPackages = with pkgs; [
      dive
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.docker;
in {
  options.chonkos.docker = {
    enable = mkEnableOption "enable docker";
  };

  config = mkIf cfg.enable {
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

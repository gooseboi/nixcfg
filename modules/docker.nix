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
        enableOnBoot = false;
      };
    };

    users.extraGroups.docker.members = [config.chonkos.user];

    environment.shellAliases.docc = "docker compose";

    # TODO: Docker compose can't find buildx (problem with nixpkgs:
    # https://github.com/nixos/nixpkgs/issues/424333)
    environment.systemPackages = with pkgs; [
      dive
      docker-buildx
      docker-compose
    ];
  };
}

{
  pkgs,
  config,
  lib,
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
      podman = {
        enable = true;

        dockerCompat = true;

        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-compose
    ];
  };
}

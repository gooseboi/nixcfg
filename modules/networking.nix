{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.networking.networkmanager.enable {
    systemd.network.wait-online.enable = false;
  };
}

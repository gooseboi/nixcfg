{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  inherit
    (lib)
    mkService
    ;

  cfg = config.chonkos.services.vaultwarden;

  remoteDomain = "${cfg.subDomain}.${domain}";
in {
  options.chonkos.services.vaultwarden = mkService {
    name = "vaultwarden";
    port = 8222;
    dir = "/var/lib/bitwarden_rs";
    package = pkgs.vaultwarden;
    subDomain = "pass";
  };

  config = {
    services.vaultwarden = {
      inherit (cfg) enable;

      dbBackend = "sqlite";

      environmentFile = config.age.secrets.vaultwarden-envfile.path;
      config = {
        DOMAIN = "https://${remoteDomain}";
        LOG_FILE = "${cfg.dataDir}/access.log";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
        SIGNUPS_ALLOWED = false;
      };
    };

    chonkos.services.reverse-proxy.hosts.vaultwarden = {
      target = "http://127.0.0.1:${toString cfg.port}";
      targetType = "tcp";
      remote = "http://${remoteDomain}";
    };
  };
}

{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
  inherit (config.networking) domain;

  enable = true;

  port = 8222;
  dataDir = "/var/lib/bitwarden_rs";
  subDomain = "pass";

  remoteDomain = "${subDomain}.${domain}";
in {
  config = mkIf enable {
    age.secrets.vaultwarden-envfile.file = ./secrets/vaultwarden-envfile.age;

    services.vaultwarden = {
      inherit enable;

      dbBackend = "sqlite";

      environmentFile = config.age.secrets.vaultwarden-envfile.path;
      config = {
        DOMAIN = "https://${remoteDomain}";
        LOG_FILE = "${dataDir}/access.log";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        SIGNUPS_ALLOWED = false;
      };
    };

    chonkos.services.reverse-proxy.hosts.vaultwarden = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${remoteDomain}";
    };
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  inherit (lib) mkConst;

  cfg = config.chonkos.services.vaultwarden;
in {
  options.chonkos.services.vaultwarden = {
    enable = mkConst true;
    enableReverseProxy = mkConst true;
    serviceName = mkConst "vaultwarden";
    servicePort = mkConst 8222;
    serviceDir = mkConst "/var/lib/bitwarden_rs";
    serviceSubDomain = mkConst "pass";
  };

  config = {
    services.vaultwarden = {
      inherit (cfg) enable;

      dbBackend = "sqlite";

      environmentFile = config.age.secrets.vaultwarden-envfile.path;
      config = {
        DOMAIN = "https://${cfg.serviceSubDomain}.${domain}";
        LOG_FILE = "${cfg.serviceDir}/access.log";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.servicePort;
        SIGNUPS_ALLOWED = false;
      };
    };
  };
}

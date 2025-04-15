{
  config,
  lib,
  ...
}: let
  inherit (lib) mkConst;
  cfg = config.chonkos.services.stirling-pdf;
in {
  options.chonkos.services.stirling-pdf = {
    serviceName = mkConst "stirling-pdf";
    servicePort = mkConst 8080;
    serviceDir = mkConst "/var/lib/bitwarden_rs";
    serviceSubDomain = mkConst "pdf";
  };

  config = {
    services.stirling-pdf = {
      enable = true;
      environment = {
        SERVER_HOST = "127.0.0.1";
        SERVER_PORT = cfg.servicePort;
      };
    };
  };
}

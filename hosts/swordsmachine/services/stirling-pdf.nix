{
  config,
  lib,
  pkgs,
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
      package = pkgs.stirling-pdf.override {
        jre = pkgs.temurin-jre-bin-21.override {gtkSupport = false;};
      };

      environment = {
        SERVER_HOST = "127.0.0.1";
        SERVER_PORT = cfg.servicePort;
      };
    };
  };
}

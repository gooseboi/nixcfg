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
    enable = mkConst true;
    enableReverseProxy = mkConst true;
    serviceName = mkConst "stirling-pdf";
    servicePort = mkConst 8080;
    serviceDir = mkConst null;
    serviceSubDomain = mkConst "pdf";
  };

  config = {
    services.stirling-pdf = {
      inherit (cfg) enable;

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

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService;
  inherit (config.networking) domain;
  cfg = config.chonkos.services.stirling-pdf;
in {
  options.chonkos.services.stirling-pdf = mkService {
    name = "stirling-pdf";
    port = 8080;
    dir = null;
    package = pkgs.stirling-pdf.override {
      jre = pkgs.temurin-jre-bin-21.override {gtkSupport = false;};
    };
  };

  config = {
    services.stirling-pdf = {
      inherit (cfg) enable;

      inherit (cfg) package;

      environment = {
        SERVER_HOST ="127.0.0.1";
        SERVER_PORT = cfg.port;
      };
    };

    chonkos.services.reverse-proxy.hosts.stirling-pdf = {
      target = "http://127.0.0.1:${toString cfg.port}";
      targetType = "tcp";
      remote = "http://manga.${domain}";
      enableAnubis = true;
    };
  };
}

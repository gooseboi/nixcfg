{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService;
  cfg = config.chonkos.services.stirling-pdf;
in {
  options.chonkos.services.stirling-pdf = mkService {
    name = "stirling-pdf";
    port = 8080;
    dir = null;
    package = pkgs.stirling-pdf.override {
      jre = pkgs.temurin-jre-bin-21.override {gtkSupport = false;};
    };

    subDomain = "pdf";
    isWeb = true;
    enableReverseProxy = true;
    enableAnubis = true;
  };

  config = {
    services.stirling-pdf = {
      inherit (cfg) enable;

      inherit (cfg) package;

      environment = {
        SERVER_HOST = "127.0.0.1";
        SERVER_PORT = cfg.port;
      };
    };
  };
}

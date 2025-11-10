{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
  inherit (config.networking) domain;

  enable = true;

  port = 8080;
  package = pkgs.stirling-pdf.override {
    jre = pkgs.temurin-jre-bin-21.override {gtkSupport = false;};
  };
in {
  config = mkIf enable {
    services.stirling-pdf = {
      inherit enable;

      inherit package;

      environment = {
        SERVER_HOST = "127.0.0.1";
        SERVER_PORT = port;
      };
    };

    chonkos.services.reverse-proxy.hosts.stirling-pdf = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "pdf.${domain}";
      enableAnubis = true;
    };
  };
}

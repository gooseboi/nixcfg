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
    jdk25 = pkgs.temurin-bin-25.override {gtkSupport = false;};
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

      anubis = {
        enable = true;
        allowedPaths = [
          {
            name = "api";
            regex = "^/api/.*$";
          }
        ];
      };
    };
  };
}

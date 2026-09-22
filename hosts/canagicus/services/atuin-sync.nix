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

  port = 8875;
in {
  config = mkIf enable {
    services.atuin = {
      enable = true;
      inherit port;

      database = {
        uri = "postgres://atuin?host=/run/postgresql";
        createLocally = false;
      };

      maxHistoryLength = 65536;
    };

    chonkos.services.postgresql.ensure = ["atuin"];

    chonkos.services.reverse-proxy.hosts.atuin = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "atuin.${domain}";
    };
  };
}

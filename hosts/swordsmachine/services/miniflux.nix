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

  port = 4034;
  package = pkgs.miniflux;
  subDomain = "mf";

  serviceDomain = "${subDomain}.${domain}";
in {
  config = mkIf enable {
    age.secrets.miniflux-admincredentials.file = ./secrets/miniflux-admincredentials.age;

    services.miniflux = {
      inherit enable package;
      config = {
        LISTEN_ADDR = "127.0.0.1:${toString port}";
        BASE_URL = "https://${serviceDomain}";
        DATABASE_URL = "user=miniflux host=/run/postgresql dbname=miniflux";

        FETCH_YOUTUBE_WATCH_TIME = "1";
        BATCH_SIZE = "200";
        POLLING_FREQUENCY = "30";
      };

      adminCredentialsFile = config.age.secrets.miniflux-admincredentials.path;
    };

    chonkos.services.postgresql.ensure = ["miniflux"];

    systemd.services.miniflux = {
      after = ["postgresql.target"];
      requires = ["postgresql.target"];
    };

    chonkos.services.reverse-proxy.hosts.miniflux = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${serviceDomain}";
      enableAnubis = true;
    };
  };
}

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

  port = 3033;
  dataDir = "/var/lib/linkwarden";
  package = pkgs.linkwarden;
  subDomain = "lw";

  serviceDomain = "${subDomain}.${domain}";
in {
  config = mkIf enable {
    age.secrets.linkwarden-envfile.file = ./secrets/linkwarden-envfile.age;

    services.restic.backups.computer = {
      paths = [dataDir];
    };

    services.linkwarden = {
      inherit enable package;

      storageLocation = dataDir;
      host = "127.0.0.1";
      inherit port;

      enableRegistration = false;

      environmentFile = config.age.secrets.linkwarden-envfile.path;

      database = {
        createLocally = false;

        host = "/run/postgresql";
        name = "linkwarden";
        user = "linkwarden";
      };
    };

    chonkos.services.postgresql.ensure = ["linkwarden"];
    systemd.services.linkwarden = {
      after = ["postgresql.target"];
      requires = ["postgresql.target"];
    };

    chonkos.services.reverse-proxy.hosts.linkwarden = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${serviceDomain}";
      enableAnubis = true;
      anubisAllowedPaths = [
        {
          name = "api-v1";
          regex = "^/api/v1.*$";
        }
        {
          name = "api-v2";
          regex = "^/api/v2.*$";
        }
      ];
    };
  };
}

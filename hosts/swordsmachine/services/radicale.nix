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

  port = 5232;
  dataDir = "/var/lib/radicale";
  subDomain = "cal";

  collectionPath = "${dataDir}/collections";
in {
  config = mkIf enable {
    # I don't really care about the passwords
    services.restic.backups.computer = {
      paths = [collectionPath];
      exclude = [
        "${collectionPath}/**/.Radicale.cache"
        "${collectionPath}/.Radicale.lock"
      ];
    };

    services.radicale = {
      inherit enable;

      settings = {
        server = {
          hosts = ["127.0.0.1:${toString port}" "[::1]:${toString port}"];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = "${dataDir}/users";
          htpasswd_encryption = "bcrypt";
        };
        storage = {
          filesystem_folder = collectionPath;
        };
      };
    };

    chonkos.services.reverse-proxy.hosts.radicale = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
    };
  };
}

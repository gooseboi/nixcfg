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
in {
  config = mkIf enable {
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
          filesystem_folder = "${dataDir}/collections";
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

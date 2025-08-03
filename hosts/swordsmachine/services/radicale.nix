{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService;

  cfg = config.chonkos.services.radicale;
in {
  options.chonkos.services.radicale = mkService {
    name = "radicale";
    port = 5232;
    dir = "/var/lib/radicale";
    package = pkgs.radicale;

    subDomain = "cal";
    isWeb = true;
    enableReverseProxy = true;
    enableAnubis = false;
  };

  config = {
    services.radicale = {
      inherit (cfg) enable;

      package = cfg.package;

      settings = {
        server = {
          hosts = ["127.0.0.1:${toString cfg.port}" "[::1]:${toString cfg.port}"];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = "${cfg.dataDir}/users";
          htpasswd_encryption = "bcrypt";
        };
        storage = {
          filesystem_folder = "${cfg.dataDir}/collections";
        };
      };
    };
  };
}

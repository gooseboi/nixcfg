{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkConst;
  cfg = config.chonkos.services.radicale;
in {
  options.chonkos.services.radicale = {
    enable = mkConst true;
    enableReverseProxy = mkConst true;
    enableAnubis = mkConst false;
    serviceName = mkConst "radicale";
    servicePort = mkConst 5232;
    serviceDir = mkConst "/var/lib/radicale";
    serviceSubDomain = mkConst "cal";
  };

  config = {
    services.radicale = {
      inherit (cfg) enable;

      settings = {
        server = {
          hosts = ["127.0.0.1:${toString cfg.servicePort}" "[::1]:${toString cfg.servicePort}"];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = "${cfg.serviceDir}/users";
          htpasswd_encryption = "bcrypt";
        };
        storage = {
          filesystem_folder = "${cfg.serviceDir}/collections";
        };
      };
    };
  };
}

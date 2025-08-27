{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  inherit (lib) mkService;

  cfg = config.chonkos.services.grafana;
  fqdn = "${cfg.subDomain}.${domain}";
in {
  options.chonkos.services.grafana = mkService {
    name = "grafana";
    port = 8021;
    dir = "/var/lib/grafana";
    package = pkgs.grafana;

    subDomain = "metrics";
    isWeb = true;
    enableReverseProxy = true;
    enableAnubis = true;
  };

  config = {
    services.grafana = {
      inherit (cfg) enable;
      inherit (cfg) package;

      dataDir = cfg.dataDir;

      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = cfg.port;
          enforce_domain = false;
          enable_gzip = true;
          domain = fqdn;
        };

        database = {
          type = "sqlite3";
        };

        users.default_theme = "dark";

        analytics.reporting_enabled = false;

        security = {
          admin_email = "${cfg.subDomain}@${domain}";
          admin_password = "$__file{${config.age.secrets.grafana-adminpassword.path}}";
          admin_user = "admin";

          cookie_secure = true;
          disable_gravatar = true;

          disable_initial_admin_creation = false;
        };
      };
    };
  };
}

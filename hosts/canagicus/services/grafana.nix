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

  port = 8021;
  dataDir = "/var/lib/grafana";
  package = pkgs.grafana;
  subDomain = "metrics";

  fqdn = "${subDomain}.${domain}";
in {
  config = mkIf enable {
    # This isn't documented in the module options but the service is ran as the
    # user `grafana`.
    age.secrets = {
      grafana-adminpassword = {
        mode = "400";
        owner = "grafana";
        file = ./secrets/grafana-adminpassword.age;
      };
      grafana-secretkey = {
        mode = "400";
        owner = "grafana";
        file = ./secrets/grafana-secretkey.age;
      };
    };

    services.grafana = {
      inherit enable;
      inherit package;

      inherit dataDir;

      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = port;
          enforce_domain = false;
          enable_gzip = true;
          domain = fqdn;
        };

        database = {
          type = "postgres";

          host = "/run/postgresql";
          user = "grafana";
          name = "grafana";
        };

        users.default_theme = "dark";

        analytics.reporting_enabled = false;

        security = {
          admin_email = "${subDomain}@${domain}";
          admin_password = "$__file{${config.age.secrets.grafana-adminpassword.path}}";
          admin_user = "admin";

          secret_key = "$__file{${config.age.secrets.grafana-secretkey.path}}";

          cookie_secure = true;
          disable_gravatar = true;

          disable_initial_admin_creation = false;
        };
      };
    };

    chonkos.services.postgresql.ensure = ["grafana"];

    chonkos.services.reverse-proxy.hosts.grafana = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${fqdn}";
      enableAnubis = true;
    };
  };
}

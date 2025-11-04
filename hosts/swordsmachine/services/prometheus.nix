{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;

  enable = true;

  port = 9090;
  dataDir = "/var/lib/prometheus";
in {
  config = mkIf enable {
    services.grafana.provision.datasources.settings = {
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString port}";
          isDefault = true;
          editable = false;

          orgId = 1;
        }
      ];

      deleteDatasources = [
        {
          name = "Prometheus";
          orgId = 1;
        }
      ];
    };

    services.prometheus = {
      inherit enable;

      inherit port;
      listenAddress = "127.0.0.1";

      stateDir = lib.removePrefix "/var/lib/" dataDir;

      retentionTime = "5w";
      globalConfig.scrape_interval = "10s";

      exporters = {
        node = {
          enable = true;
          enabledCollectors = [
            "btrfs"
            "cpu"
            "cpufreq"
            "diskstats"
            "ethtool"
            "filesystem"
            "hwmon"
            "meminfo"
            "netdev"
            "nvme"
            "powersupplyclass"
            "processes"
            "systemd"
            "tcpstat"
            "thermal_zone"
          ];
        };
      };

      # TODO: Auto generate these from `config.services.prometheus.exporters`
      scrapeConfigs = [
        {
          job_name = "node_exporter";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
      ];
    };
  };
}

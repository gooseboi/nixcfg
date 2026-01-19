{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    filterAttrs
    mapAttrsToList
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

      scrapeConfigs =
        (config.services.prometheus.exporters
          // config.chonkos.services.prometheus.exporters)
        |> filterAttrs (exporterName: exporterConfig:
          !(builtins.elem exporterName [
            # Removed modules
            "minio"
            "tor"
            "unifi-poller"

            # Don't have config
            "assertions"
            "warnings"
          ])
          && exporterConfig.enable)
        |> mapAttrsToList (exporterName: exporterConfig: {
          job_name = exporterName;

          static_configs = [
            {
              targets = ["127.0.0.1:${toString exporterConfig.port}"];
            }
          ];
        });
    };
  };
}

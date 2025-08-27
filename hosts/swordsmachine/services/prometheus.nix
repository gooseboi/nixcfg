{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService;

  cfg = config.chonkos.services.prometheus;
in {
  options.chonkos.services.prometheus = mkService {
    name = "prometheus";
    port = 9090;
    dir = "/var/lib/prometheus";
    package = pkgs.prometheus;

    isWeb = false;
  };

  config = {
    services.grafana.provision.datasources.settings = {
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString cfg.port}";
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
      inherit (cfg) enable package;

      inherit (cfg) port;
      listenAddress = "127.0.0.1";

      stateDir = lib.removePrefix "/var/lib/" cfg.dataDir;

      exporters = {
        node = {
          enable = true;
          enabledCollectors = [
            "boottime"
            "btrfs"
            "cpu"
            "cpu"
            "cpufreq"
            "diskstats"
            "ethtool"
            "filesystem"
            "hwmon"
            "meinfo"
            "netdev"
            "nvme"
            "powersupplyclass"
            "processes"
            "systemd"
            "tcpstat"
            "thermal"
            "thermal_zone"
          ];
        };
      };

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

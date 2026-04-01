{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  prometheusCfg = config.chonkos.services.prometheus.exporters.caddy;
in {
  options.chonkos.services = {
    prometheus.exporters.caddy = {
      enable = mkEnableOption "enable caddy exporting metrics";

      listenAddress = mkOption {
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        default = 2019;
        type = types.port;
      };
    };

    caddy = {
      debug = mkEnableOption "enable caddy debug logs";
    };
  };

  config = mkMerge [
    {
      services.caddy = mkMerge [
        (mkIf config.chonkos.services.caddy.debug {
          logFormat = ''
            level DEBUG
          '';
          globalConfig = ''
            debug
          '';
        })

        (mkIf prometheusCfg.enable {
          # TODO: Set port from options
          globalConfig = ''
            metrics {
              per_host
            }
          '';
        })
      ];
    }

    (mkIf config.services.caddy.enable {
      # Hardening
      systemd.services.caddy.serviceConfig = {
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    })
  ];
}

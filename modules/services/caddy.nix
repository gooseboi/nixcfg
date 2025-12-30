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
in {
  options.chonkos.services.prometheus.exporters.caddy = {
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

  config = mkMerge [
    {
      services.caddy = let
        cfg = config.chonkos.services.prometheus.exporters.caddy;
      in {
        # TODO: Set port from options
        globalConfig = mkIf cfg.enable ''
          metrics {
            per_host
          }
        '';
      };
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

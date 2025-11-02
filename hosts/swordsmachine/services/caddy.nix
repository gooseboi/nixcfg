{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    attrsToList
    filter
    iota
    listToAttrs
    mkConst
    mkIf
    mkMerge
    ;
  inherit (builtins) toString length;

  cfg = config.chonkos.services.caddy;

  enabledServices =
    config.chonkos.services.reverse-proxy.hosts
    |> attrsToList
    |> filter ({value, ...}: value.enable);

  serviceCnt = enabledServices |> length;
  anubisPorts = iota {
    base = cfg.anubisBasePort;
    n = serviceCnt;
  };
  anubisCfg =
    lib.zipListsWith (service: port: {
      inherit service port;
    })
    (enabledServices |> filter ({value, ...}: value.enableAnubis))
    anubisPorts;

  caddyTargetFromType = type: target: ({
    "tcp" = target;
    "unix" = "unix/${target}";
  }."${type}");

  anubisTargetFromType = type: target: ({
    "tcp" = target;
    "unix" = "unix://${target}";
  }."${type}");
in {
  options.chonkos.services.caddy = {
    enable = mkConst true;
    useAnubis = mkConst true;
    anubisBasePort = mkConst 20820;
  };

  # TODO: Add metrics (https://caddyserver.com/docs/metrics)
  # TODO: X-Real-IP

  config = mkMerge [
    {
      services.caddy = {
        inherit (cfg) enable;
      };

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
    }
    (mkIf (!cfg.useAnubis) {
      services.caddy = {
        virtualHosts =
          enabledServices
          |> map ({value, ...}: {
            "${value.remote}" = {
              extraConfig = ''
                reverse_proxy ${caddyTargetFromType value.targetType value.target}
                ${value.extraCaddyConfig}
              '';
            };
          })
          |> mkMerge;
      };
    })

    (mkIf cfg.useAnubis {
      services.anubis = {
        defaultOptions.settings = {
          DIFFICULTY = 4;
          OG_PASSTHROUGH = true;
          SERVE_ROBOTS_TXT = true;
          WEBMASTER_EMAIL = "gooseiman@protonmail.com";
        };

        instances =
          anubisCfg
          |> map (v: {
            name = v.service.name;
            value = {
              inherit (cfg) enable;

              settings = {
                TARGET = anubisTargetFromType v.service.value.targetType v.service.value.target;
                BIND = "localhost:${toString v.port}";
                BIND_NETWORK = "tcp";
                # TODO: METRICS
              };
            };
          })
          |> listToAttrs;
      };

      services.caddy = {
        virtualHosts = mkMerge [
          (
            anubisCfg
            |> map ({
              service,
              port,
              ...
            }: {
              "${service.value.remote}" = {
                extraConfig = ''
                  reverse_proxy ${caddyTargetFromType "tcp" "http://localhost:${toString port}"}
                  ${service.value.extraCaddyConfig}
                '';
              };
            })
            |> mkMerge
          )

          (
            enabledServices
            |> filter ({value, ...}: !value.enableAnubis)
            |> map ({value, ...}: {
              "${value.remote}" = {
                extraConfig = ''
                  reverse_proxy ${caddyTargetFromType value.targetType value.target}
                  ${value.extraCaddyConfig}
                '';
              };
            })
            |> mkMerge
          )
        ];
      };
    })
  ];
}

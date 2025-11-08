{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    attrsToList
    filter
    listToAttrs
    mkConst
    mkIf
    mkMerge
    ;

  cfg = config.chonkos.services.caddy;

  enabledServices =
    config.chonkos.services.reverse-proxy.hosts
    |> attrsToList
    |> filter ({value, ...}: value.enable);

  anubisServices =
    enabledServices
    |> filter ({value, ...}: value.enableAnubis);

  anubisMetricsSocketName = name: "/run/anubis/anubis-${name}/anubis-${name}-metrics.sock";
  anubisInstanceSocketName = name: "/run/anubis/anubis-${name}/anubis-${name}.sock";

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
      # Anubis (by default) makes the unix socket's permissions 0770, and
      # therefore you either make them world-readable, or put the reverse proxy
      # service's user in the service's group so it can access it. The latter
      # is more restrictive so we do that.
      users.groups.anubis.members = ["caddy"];

      services.anubis = {
        defaultOptions.settings = {
          DIFFICULTY = 4;
          OG_PASSTHROUGH = true;
          SERVE_ROBOTS_TXT = true;
          WEBMASTER_EMAIL = "gooseiman@protonmail.com";
        };

        instances =
          anubisServices
          |> map (service: {
            name = service.name;
            value = {
              inherit (cfg) enable;

              settings = {
                TARGET = anubisTargetFromType service.value.targetType service.value.target;
                BIND = anubisInstanceSocketName service.name;
                BIND_NETWORK = "unix";

                # TODO: METRICS
                # This is actually to fix an evaluation warning in the nix module,
                # not because metrics is actually set up.
                METRICS_BIND = anubisMetricsSocketName service.name;
                METRICS_BIND_NETWORK = "unix";
              };
            };
          })
          |> listToAttrs;
      };

      services.caddy = {
        virtualHosts = mkMerge [
          (
            anubisServices
            |> map (service: {
              "${service.value.remote}" = {
                extraConfig = ''
                  reverse_proxy ${anubisInstanceSocketName service.name |> caddyTargetFromType "unix"}
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

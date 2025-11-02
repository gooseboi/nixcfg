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
  inherit (config) networking;

  serviceCfg = config.chonkos.services;
  cfg = serviceCfg.caddy;

  httpDomain = subDomain: "http://${subDomain}.${networking.domain}";

  enabledServices =
    serviceCfg
    |> attrsToList
    |> filter ({value, ...}: value.enable)
    |> filter ({value, ...}: value.isWeb or false)
    |> filter ({value, ...}: value.enableReverseProxy);

  serviceCnt = enabledServices |> length;
  anubisPorts = iota {
    base = cfg.anubisBasePort;
    n = serviceCnt;
  };
  anubisCfg =
    lib.zipListsWith (s: p: {
      name = s.value.name;
      subDomain = s.value.subDomain;
      origPort = s.value.port;
      anubisPort = p;
    })
    (enabledServices |> filter ({value, ...}: value.enableAnubis))
    anubisPorts;
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
            "${httpDomain value.subDomain}" = {
              extraConfig = ''
                reverse_proxy http://localhost:${toString value.port}
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
            name = v.name;
            value = {
              inherit (cfg) enable;

              settings = {
                TARGET = "http://localhost:${toString v.origPort}";
                BIND = "localhost:${toString v.anubisPort}";
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
              subDomain,
              anubisPort,
              ...
            }: {
              "${httpDomain subDomain}" = {
                extraConfig = ''
                  reverse_proxy http://localhost:${toString anubisPort}
                '';
              };
            })
            |> mkMerge
          )

          (
            enabledServices
            |> filter ({value, ...}: !value.enableAnubis)
            |> map ({value, ...}: {
              "${httpDomain value.subDomain}" = {
                extraConfig = ''
                  reverse_proxy http://localhost:${toString value.port}
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

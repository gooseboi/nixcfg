{
  lib,
  config,
  ...
}: let
  inherit (lib) attrsToList filter listToAttrs mkConst mkIf mkMerge;
  inherit (builtins) toString length;
  inherit (config) networking;

  serviceCfg = config.chonkos.services;
  cfg = serviceCfg.caddy;
in {
  options.chonkos.services.caddy = {
    enable = mkConst true;
    enableReverseProxy = mkConst false;
    useAnubis = mkConst true;
    anubisBasePort = mkConst 20820;
  };

  # TODO: X-Real-IP

  config = let
    reverse_proxy = {
      subdomain,
      domain ? null,
      port,
    }: (
      if domain != null
      then {
        "http://${domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString port}
          '';
        };
      }
      else {
        "http://${subdomain}.${networking.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString port}
          '';
        };
      }
    );

    enabledServices =
      serviceCfg
      |> attrsToList
      |> filter ({value, ...}: value.enable)
      |> filter ({value, ...}: value.enableReverseProxy);
  in
    mkMerge [
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
            |> map ({value, ...}: (reverse_proxy {
              subdomain = value.serviceSubDomain;
              port = value.servicePort;
            }))
            |> mkMerge;
        };
      })

      (mkIf cfg.useAnubis (
        let
          iota = base: n:
            if n == 0
            then []
            else [base] ++ (iota (base + 1) (n - 1));

          serviceCnt = enabledServices |> length;
          anubisPorts = iota cfg.anubisBasePort serviceCnt;

          anubisCfg =
            lib.zipListsWith (s: p: {
              serviceName = s.value.serviceName;
              subDomain = s.value.serviceSubDomain;
              origPort = s.value.servicePort;
              anubisPort = p;
            })
            enabledServices
            anubisPorts;
        in {
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
                name = v.serviceName;
                value = {
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
            virtualHosts =
              anubisCfg
              |> map ({
                subDomain,
                anubisPort,
                ...
              }: (reverse_proxy {
                subdomain = subDomain;
                port = anubisPort;
              }))
              |> mkMerge;
          };
        }
      ))
    ];
}

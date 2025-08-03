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
    useAnubis = mkConst true;
    anubisBasePort = mkConst 20820;
    isReverseProxy = mkConst true;
  };

  # TODO: X-Real-IP

  config = let
    reverse_proxy = {
      subDomain,
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
        "http://${subDomain}.${networking.domain}" = {
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
      |> filter ({value, ...}: ! (value.isReverseProxy or false))
      |> filter ({value, ...}: value.isWeb or false)
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
              inherit (value) subDomain port;
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
              name = s.value.name;
              subDomain = s.value.subDomain;
              origPort = s.value.port;
              anubisPort = p;
            })
            (enabledServices |> filter ({value, ...}: value.enableAnubis))
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
                }: (reverse_proxy {
                  subDomain = subDomain;
                  port = anubisPort;
                }))
                |> mkMerge
              )

              (
                enabledServices
                |> filter ({value, ...}: ! value.enableAnubis)
                |> map ({value, ...}: (reverse_proxy {
                  inherit (value) subDomain port;
                }))
                |> mkMerge
              )
            ];
          };
        }
      ))
    ];
}

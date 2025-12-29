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
    strings
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

  config = mkMerge [
    {
      services.caddy = {
        inherit (cfg) enable;
      };
    }
    (mkIf (!cfg.useAnubis) {
      services.caddy = {
        virtualHosts =
          enabledServices
          |> map ({value, ...}: {
            "http://${value.domain}" = {
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

              botPolicy = let
                bots =
                  service.value.anubisAllowedPaths
                  |> map ({
                    name,
                    regex,
                  }: {
                    inherit name;
                    path_regex = regex;
                    action = "ALLOW";
                  });
              in
                if builtins.length bots != 0
                then {
                  inherit bots;
                }
                else null;
            };
          })
          |> listToAttrs;
      };

      services.caddy = {
        virtualHosts = mkMerge [
          (
            anubisServices
            |> map ({
              name,
              value,
            }: {
              "http://${value.domain}" = {
                extraConfig = mkMerge [
                  ''
                    reverse_proxy ${anubisInstanceSocketName name |> caddyTargetFromType "unix"}
                  ''

                  (mkIf value.enableCompression ''
                    encode ${strings.concatStringsSep " " value.enabledCompressionAlgorithms}
                  '')

                  ''
                    ${value.extraCaddyConfig}
                  ''
                ];
              };
            })
            |> mkMerge
          )

          (
            enabledServices
            |> filter ({value, ...}: !value.enableAnubis)
            |> map ({value, ...}: {
              "http://${value.domain}" = {
                extraConfig = mkMerge [
                  ''
                    reverse_proxy ${caddyTargetFromType value.targetType value.target}
                  ''

                  (mkIf value.enableCompression ''
                    encode ${strings.concatStringsSep " " value.enabledCompressionAlgorithms}
                  '')

                  ''
                    ${value.extraCaddyConfig}
                  ''
                ];
              };
            })
            |> mkMerge
          )
        ];
      };
    })
  ];
}

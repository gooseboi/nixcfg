{
  lib,
  config,
  ...
}: let
  inherit (lib) filter mkConst mkMerge;
  inherit (config) networking;

  cfg = config.chonkos.services;
in {
  options.chonkos.services.caddy = {
    enable = mkConst true;
    enableReverseProxy = mkConst false;
    useAnubis = mkConst false;
  };

  # TODO: X-Real-IP

  config = mkMerge [
    {
      services.caddy = {
        inherit (cfg.caddy) enable;
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

    (lib.mkIf (!cfg.caddy.useAnubis) {
      services.caddy = {
        virtualHosts = let
          reverse_proxy = {
            subdomain,
            domain ? null,
            port,
          }: (
            if domain != null
            then {
              "http://${domain}" = {
                extraConfig = ''
                  reverse_proxy http://localhost:${builtins.toString port}
                '';
              };
            }
            else {
              "http://${subdomain}.${networking.domain}" = {
                extraConfig = ''
                  reverse_proxy http://localhost:${builtins.toString port}
                '';
              };
            }
          );
        in
          cfg
          |> lib.attrsToList
          |> filter ({value, ...}: value.enable)
          |> filter ({value, ...}: value.enableReverseProxy)
          |> map ({value, ...}: (reverse_proxy {
            subdomain = value.serviceSubDomain;
            port = value.servicePort;
          }))
          |> mkMerge;
      };
    })

    (lib.mkIf cfg.useAnubis {
      # TODO: Actually do it
    })
  ];
}

{
  lib,
  config,
  ...
}: let
  inherit (config) networking;

  cfg = config.chonkos.services;
in {
  # TODO: X-Real-IP

  services.caddy = {
    enable = true;
    virtualHosts = let
      reverse_proxy = {
        subdomain,
        domain ? null,
        port,
      }:
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
        };
    in
      lib.mkMerge (map ({value, ...}: (reverse_proxy {
          subdomain = value.serviceSubDomain;
          port = value.servicePort;
        }))
        (
          lib.attrsToList
          cfg
        ));
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

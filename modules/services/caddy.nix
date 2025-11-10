{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
  cfg = config.services.caddy;
in {
  # TODO: Add metrics (https://caddyserver.com/docs/metrics)
  config = mkIf cfg.enable {
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
  };
}

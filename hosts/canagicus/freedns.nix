{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  age.secrets.freedns-token.file = ./secrets/freedns-token.age;

  systemd.timers."freedns-update" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "freedns-update.service";
    };
  };

  systemd.services."freedns-update" = {
    after = ["network.target"];
    requires = ["network.target"];
    script = ''
      set -eux

      ${getExe pkgs.curl} \
        --silent --show-error \
        --get \
        --retry 3 --retry-delay 5 --max-time 10 \
        --data-urlencode "@${config.age.secrets.freedns-token.path}" \
        https://freedns.afraid.org/dynamic/update.php
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";

      # Hardening
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

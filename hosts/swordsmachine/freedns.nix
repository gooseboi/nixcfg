{
  config,
  pkgs,
  ...
}: {
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
    script = ''
      set -eux

      TOKEN="$(cat ${config.age.secrets.freedns-token.path})"
      ${pkgs.curl}/bin/curl https://freedns.afraid.org/dynamic/update.php?$TOKEN
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}

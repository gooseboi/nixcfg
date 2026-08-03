{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
  inherit (config.networking) domain;

  enable = true;

  driveMountPath = "/media/immich";

  port = 4475;
in {
  config = mkIf enable {
    services.immich = {
      enable = true;
      inherit port;
      host = "127.0.0.1";

      mediaLocation = driveMountPath;

      database = {
        createDB = false;
        host = "/run/postgresql";
      };
    };

    systemd.mounts = [
      {
        type = "btrfs";
        what = "/dev/disk/by-uuid/a5e9b07f-e704-416b-ab0c-dd67310087f1";
        where = driveMountPath;
        wantedBy = [
          "immich-server.service"
        ];
      }
    ];

    chonkos.services.postgresql.ensure = ["immich"];

    chonkos.services.reverse-proxy.hosts.immich = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "img.${domain}";
    };
  };
}

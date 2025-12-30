{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkForce
    mkIf
    mkMerge
    mkOption
    types
    ;

  user = "miniflux";
  group = "miniflux";
in {
  options.chonkos.services.prometheus.exporters.miniflux = {
    enable = mkEnableOption "enable caddy exporting metrics";

    listenAddress = mkOption {
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      type = types.port;
    };
  };

  config = mkMerge [
    {
      services.miniflux = {
        config = mkIf config.chonkos.services.prometheus.exporters.miniflux.enable {
          METRICS_COLLECTOR = 1;
          METRICS_REFRESH_INTERVAL = 30;
        };
      };
    }
    (mkIf config.services.miniflux.enable {
      users = {
        users.${user} = {
          inherit group;
          isSystemUser = true;
        };
        groups.${group} = {};
      };

      systemd.services.miniflux = {
        serviceConfig = {
          User = user;
          Group = group;

          PrivateUsers = mkForce false;
        };
      };
    })
  ];
}

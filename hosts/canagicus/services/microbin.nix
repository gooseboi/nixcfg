{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;

  enable = true;

  subDomain = "bin";
  inherit (config.networking) domain;

  port = 45673;
in {
  config = mkIf enable {
    services.microbin = {
      enable = true;

      settings = {
        MICROBIN_PORT = port;

        MICROBIN_PRIVATE = true;
        MICROBIN_EDITABLE = false;
      };
    };

    chonkos.services.reverse-proxy.hosts.microbin = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
    };
  };
}

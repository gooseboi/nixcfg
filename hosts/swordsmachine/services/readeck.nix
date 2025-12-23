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

  port = 8023;
  dataDir = "/var/lib/readeck";
  subDomain = "rck";
in {
  # TODO: This should probably the refactored because this service uses user root.
  config = mkIf enable {
    age.secrets.readeck-envfile.file = ./secrets/readeck-envfile.age;

    services.readeck = {
      inherit enable;

      settings = {
        main = {
          log_level = "debug";
          data_directory = dataDir;
        };

        server = {
          host = "127.0.0.1";
          inherit port;
        };
      };

      environmentFile = config.age.secrets.readeck-envfile.path;
    };

    chonkos.services.reverse-proxy.hosts.readeck = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
    };
  };
}

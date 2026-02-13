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

  port = 4376;
  dataDir = "/var/lib/komga";
in {
  config = mkIf enable {
    services.komga = {
      inherit enable;

      stateDir = dataDir;

      settings = {
        server = {
          ip = "127.0.0.1";
          port = port;

          extensionRepos = [
            "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          ];
        };
      };
    };

    chonkos.services.reverse-proxy.hosts.komga = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "manga.${domain}";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
  inherit (config.networking) domain;

  enable = true;

  port = 4567;
  dataDir = "/var/lib/suwayomi-server";
  package = pkgs.suwayomi-server.override {
    jdk21_headless = pkgs.temurin-jre-bin-21.override {
      gtkSupport = false;
    };
  };
in {
  config = mkIf enable {
    services.suwayomi-server = {
      inherit enable;

      inherit package;

      dataDir = dataDir;

      settings.server = {
        ip = "127.0.0.1";
        port = port;

        downloadAsCbz = false;
        systemTrayEnabled = false;

        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        ];
      };
    };

    chonkos.services.reverse-proxy.hosts.suwayomi-server = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      remote = "http://manga.${domain}";
    };
  };
}

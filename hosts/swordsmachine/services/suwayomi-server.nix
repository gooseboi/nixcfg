{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService;
  inherit (config.networking) domain;
  cfg = config.chonkos.services.suwayomi-server;
in {
  options.chonkos.services.suwayomi-server = mkService {
    name = "suwayomi-server";
    port = 4567;
    dir = "/var/lib/suwayomi-server";
    package = pkgs.suwayomi-server.override {
      jdk21_headless = pkgs.temurin-jre-bin-21.override {
        gtkSupport = false;
      };
    };
  };

  config = {
    services.suwayomi-server = {
      inherit (cfg) enable;

      inherit (cfg) package;

      dataDir = cfg.dataDir;

      settings.server = {
        ip = "127.0.0.1";
        port = cfg.port;

        downloadAsCbz = false;
        systemTrayEnabled = false;

        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        ];
      };
    };

    chonkos.services.reverse-proxy.hosts.suwayomi-server = {
      target = "http://127.0.0.1:${toString cfg.port}";
      targetType = "tcp";
      remote = "http://manga.${domain}";
    };
  };
}

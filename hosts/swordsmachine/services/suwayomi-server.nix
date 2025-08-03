{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService;
  cfg = config.chonkos.services.suwayomi-server;
in {
  options.chonkos.services.suwayomi-server = mkService {
    name = "suwayomi-server";
    port = 4567;
    dir = "/var/lib/suwayomi-server";
    package = pkgs.suwayomi-server.override {
      jdk17_headless = pkgs.temurin-jre-bin-17.override {
        gtkSupport = false;
      };
    };

    subDomain = "manga";
    isWeb = true;
    enableReverseProxy = true;
    enableAnubis = true;
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
  };
}

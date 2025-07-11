{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkConst;
  cfg = config.chonkos.services.suwayomi-server;
in {
  options.chonkos.services.suwayomi-server = {
    enable = mkConst true;
    enableReverseProxy = mkConst true;
    enableAnubis = mkConst true;
    serviceName = mkConst "suwayomi-server";
    servicePort = mkConst 4567;
    serviceDir = mkConst "/var/lib/suwayomi-server";
    serviceSubDomain = mkConst "manga";
  };

  config = {
    services.suwayomi-server = {
      inherit (cfg) enable;

      package = pkgs.suwayomi-server.override {
        jdk17_headless = pkgs.temurin-jre-bin-17.override {
          gtkSupport = false;
        };
      };

      dataDir = cfg.serviceDir;
      settings.server = {
        ip = "127.0.0.1";
        port = cfg.servicePort;

        downloadAsCbz = false;
        systemTrayEnabled = false;

        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        ];
      };
    };
  };
}

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

  enable = false;

  port = 4567;
  dataDir = "/var/lib/suwayomi-server";
  package = pkgs.suwayomi-server.override {
    jdk21_headless = pkgs.temurin-jre-bin-21.override {
      gtkSupport = false;
    };
  };
in {
  config = mkIf enable {
    age.secrets.suwayomi-server-passwordfile.file = ./secrets/suwayomi-server-passwordfile.age;

    services.suwayomi-server = {
      inherit enable;

      inherit package;

      dataDir = dataDir;

      settings.server = {
        ip = "127.0.0.1";
        port = port;

        basicAuthEnabled = true;
        basicAuthUsername = "chonk";
        basicAuthPasswordFile = config.age.secrets.suwayomi-server-passwordfile.path;

        downloadAsCbz = false;
        systemTrayEnabled = false;
        initialOpenInBrowserEnabled = false;

        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
        ];
      };
    };

    chonkos.services.reverse-proxy.hosts.suwayomi-server = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "suwayomi.${domain}";
    };
  };
}

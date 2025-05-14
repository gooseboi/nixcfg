{
  config,
  lib,
  ...
}: let
  inherit (lib) mkConst;
  cfg = config.chonkos.services.suwayomi-server;
in {
  options.chonkos.services.suwayomi-server = {
    serviceName = mkConst "suwayomi-server";
    servicePort = mkConst 4567;
    serviceDir = mkConst "/var/lib/suwayomi-server";
    serviceSubDomain = mkConst "manga";
  };

  config = {
    services.suwayomi-server = {
      enable = true;
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

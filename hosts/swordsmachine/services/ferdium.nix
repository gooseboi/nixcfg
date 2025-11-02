{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  inherit (lib) mkService;

  cfg = config.chonkos.services.ferdium;

  fqdn = "${cfg.subDomain}.${domain}";

  serviceName = "ferdium-server";

  stateDirName = serviceName;
  stateDir = "/var/lib/${stateDirName}";
  dataDir = "${stateDir}/data";
  recipesDir = "${stateDir}/recipes";
  systemdServiceName = "${config.virtualisation.oci-containers.backend}-${serviceName}";
in {
  options.chonkos.services.ferdium = mkService {
    name = serviceName;
    port = 3333;
    dir = stateDir;
    package = null;
    subDomain = "ferdium";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.${systemdServiceName}.serviceConfig = {
      StateDirectory = "${stateDirName}";
    };

    systemd.tmpfiles.rules = [
      "d ${recipesDir} 0775 - - - -"
      "d ${dataDir} 0775 - - - -"
    ];

    virtualisation.oci-containers.containers = {
      "${serviceName}" = {
        image = "docker.io/ferdium/ferdium-server";
        autoStart = true;

        volumes = [
          "${dataDir}:/data"
          "${recipesDir}:/app/recipes"
        ];
        ports = ["127.0.0.1:${builtins.toString cfg.port}:3333"];
        environment = {
          NODE_ENV = "production";
          APP_URL = "https://${fqdn}";
          DB_CONNECTION = "sqlite";
          IS_CREATION_ENABLED = "true";
          IS_DASHBOARD_ENABLED = "true";
          IS_REGISTRATION_ENABLED = "false";
          CONNECT_WITH_FRANZ = "false";
          DATA_DIR = "/data";
          JWT_USE_PEM = "true";
        };
      };
    };

    chonkos.services.reverse-proxy.hosts.ferdium = {
      target = "http://127.0.0.1:${toString cfg.port}";
      targetType = "tcp";
      remote = "http://${fqdn}";
      enableAnubis = true;
    };
  };
}

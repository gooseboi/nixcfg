{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  inherit (lib) mkConst;

  cfg = config.chonkos.services.ferdium;

  serviceName = "ferdium-server";

  stateDirName = serviceName;
  stateDir = "/var/lib/${stateDirName}";
  dataDir = "${stateDir}/data";
  recipesDir = "${stateDir}/recipes";
  systemdServiceName = "${config.virtualisation.oci-containers.backend}-${serviceName}";
in {
  options.chonkos.services.ferdium = {
    enable = mkConst true;
    enableReverseProxy = mkConst true;
    enableAnubis = mkConst false;
    serviceName = mkConst serviceName;
    servicePort = mkConst 3333;
    serviceDir = mkConst stateDir;
    serviceSubDomain = mkConst "ferdium";
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
        ports = ["127.0.0.1:${builtins.toString cfg.servicePort}:3333"];
        environment = {
          NODE_ENV = "production";
          APP_URL = "https://${cfg.serviceSubDomain}.${domain}";
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
  };
}

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

  port = 3333;
  subDomain = "ferdium";

  fqdn = "${subDomain}.${domain}";

  serviceName = "ferdium-server";

  stateDirName = serviceName;
  stateDir = "/var/lib/${stateDirName}";
  dataDir = "${stateDir}/data";
  recipesDir = "${stateDir}/recipes";
  systemdServiceName = "${config.virtualisation.oci-containers.backend}-${serviceName}";
in {
  config = mkIf enable {
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
        ports = ["127.0.0.1:${builtins.toString port}:3333"];
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
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${fqdn}";
    };
  };
}

{config, ...}: let
  serviceName = "ferdium-server";
  user = serviceName;
  group = serviceName;

  stateDirName = serviceName;
  stateDir = "/var/lib/${stateDirName}";
  dataDir = "${stateDir}/data";
  recipesDir = "${stateDir}/recipes";
  systemdServiceName = "${config.virtualisation.oci-containers.backend}-${serviceName}";
in {
  assertions = [
    {
      assertion = config.virtualisation.oci-containers.backend == "podman";
      message = ''
        This doesn't work with docker.
      '';
    }
  ];

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
      ports = ["127.0.0.1:3333:3333"];
      environment = {
        NODE_ENV = "production";
        APP_URL = "https://ferdium.gooseman.net";
        DB_CONNECTION = "sqlite";
        IS_CREATION_ENABLED = "true";
        IS_DASHBOARD_ENABLED = "true";
        IS_REGISTRATION_ENABLED = "true";
        CONNECT_WITH_FRANZ = "false";
        DATA_DIR = "/data";
        JWT_USE_PEM = "true";
      };
    };
  };
}

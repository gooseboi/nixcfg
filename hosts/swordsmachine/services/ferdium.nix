{config, ...}: let
  serviceName = "ferdium-server";
  user = serviceName;
  group = serviceName;

  stateDirName = serviceName;
  stateDir = "/var/lib/${stateDirName}";
  dataDir = "${stateDir}/data";
  recipesDir = "${stateDir}/recipes";
in {
  assertions = [
    {
      assertion = config.virtualisation.oci-containers.backend == "podman";
      message = ''
        This doesn't work with docker.
      '';
    }
  ];

  users.users.${user} = {
    group = group;
    isSystemUser = true;
  };
  users.groups.${group} = {};

  systemd.services."${config.virtualisation.oci-containers.backend}-${serviceName}".serviceConfig = {
    StateDirectory = "${stateDirName}";
  };

  virtualisation.oci-containers.containers = {
    "${serviceName}" = {
      image = "docker.io/ferdium/ferdium-server";
      autoStart = true;

      user = "${user}:{group}";
      podman.user = user;

      volumes = [
        "${dataDir}:/data"
        "${recipesDir}:/app/recipes"
      ];
      ports = ["127.0.0.1:3333:3333"];
      environment = {
        NODE_ENV = "production";
        APP_URL = "https://ferdium.gooseman.net";
        DB_CONNECTION = "sqlite";
        IS_CREATION_ENABLED = "false";
        IS_DASHBOARD_ENABLED = "true";
        IS_REGISTRATION_ENABLED = "false";
        CONNECT_WITH_FRANZ = "false";
        DATA_DIR = "/data";
        JWT_USE_PEM = "true";
      };
    };
  };
}

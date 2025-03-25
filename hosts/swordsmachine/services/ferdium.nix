{...}: {
  virtualisation.oci-containers.containers = {
    ferdium-server = {
      image = "ferdium/ferdium-server";
      autoStart = true;
      ports = ["127.0.0.1:1234:1234"];
    };
  };
}

{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers.enigmatica = {
        enable = true;
        src = "e2e.gooseman.net";
        dest = "localhost:25566";
      };

      servers.ciscorpg = {
        enable = true;
        src = "ciscorpg.gooseman.net";
        dest = "localhost:25567";
      };
    };
  };
}

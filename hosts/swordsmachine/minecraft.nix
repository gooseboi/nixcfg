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

      servers.deceased = {
        enable = true;
        src = "deceased.gooseman.net";
        dest = "localhost:25567";
      };
    };
  };
}

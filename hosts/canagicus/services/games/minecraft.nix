{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers = {
        gtnh = {
          src = "gtnh.mc.gooseman.net";
          dest = "localhost:25576";
        };

        terra = {
          src = "terra.mc.gooseman.net";
          dest = "localhost:25577";
        };
      };
    };
  };
}

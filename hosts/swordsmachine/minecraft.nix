{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers.cobblemon = {
        enable = true;
        src = "cobblemon.gooseman.net";
        dest = "localhost:25564";
      };
    };
  };
}

{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers.cobblemon = {
        enable = true;
        src = "e2e.gooseman.net";
        dest = "localhost:25566";
      };
    };
  };
}

{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers.homestead = {
        enable = true;
        src = "hstead.gooseman.net";
        dest = "localhost:25566";
      };
    };
  };
}

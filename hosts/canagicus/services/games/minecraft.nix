{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers.gtnh = {
        enable = true;
        src = "gtnh.mc.gooseman.net";
        dest = "localhost:25576";
      };
    };
  };
}

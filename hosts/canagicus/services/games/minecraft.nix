{
  config = {
    chonkos.services.mc-gate = {
      enable = true;
      openFirewall = true;

      servers.homestead = {
        enable = true;
        src = "hstead.mc.gooseman.net";
        dest = "localhost:25566";
      };

      servers.vault_hunters = {
        enable = true;
        src = "vh.mc.gooseman.net";
        dest = "localhost:25569";
      };
    };
  };
}

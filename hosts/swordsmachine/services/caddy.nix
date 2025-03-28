{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://pass.gooseman.net" = {
        extraConfig = ''
          reverse_proxy http://localhost:8222
        '';
      };
    };
  };
}

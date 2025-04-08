{lib, ...}: {
  services.caddy = {
    enable = true;
    virtualHosts = let
      reverse_proxy = {
        domain,
        port,
      }: {
        "http://${domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${builtins.toString port}
          '';
        };
      };
    in
      lib.mkMerge [
        (reverse_proxy {
          domain = "pass.gooseman.net";
          port = 8222;
        })
        (reverse_proxy {
          domain = "ferdium.gooseman.net";
          port = 3333;
        })
      ];
  };
}

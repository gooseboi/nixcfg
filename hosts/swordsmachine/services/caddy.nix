{
  lib,
  config,
  ...
}: let
  inherit (config) networking;
in {
  services.caddy = {
    enable = true;
    virtualHosts = let
      reverse_proxy = {
        subdomain,
        domain ? null,
        port,
      }:
        if domain != null
        then {
          "http://${domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${builtins.toString port}
            '';
          };
        }
        else {
          "http://${subdomain}.${networking.domain}" = {
            extraConfig = ''
              reverse_proxy http://localhost:${builtins.toString port}
            '';
          };
        };
    in
      lib.mkMerge [
        (reverse_proxy {
          subdomain = "pass";
          port = 8222;
        })
        (reverse_proxy {
          subdomain = "ferdium";
          port = 3333;
        })
        (reverse_proxy {
          subdomain = "git";
          port = 3000;
        })
      ];
  };
}

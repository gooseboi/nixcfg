{
  lib,
  self,
  ...
}: let
  inherit
    (lib)
    attrsToList
    mkIf
    mkMerge
    ;

  enable = true;
in {
  config = mkIf enable {
    networking.firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [80 443];
    };

    services.caddy = {
      enable = true;

      virtualHosts =
        self.nixosConfigurations.canagicus.config.chonkos.services.reverse-proxy.hosts
        |> attrsToList
        |> map ({value, ...}: {
          "https://${value.domain}" = {
            extraConfig = ''
              # Using tailscale
              reverse_proxy http://canagicus {
                header_up X-Real-IP {remote_host}
              }
            '';
          };
        })
        |> mkMerge;

      email = "gooseiman@protonmail.com";
    };
  };
}

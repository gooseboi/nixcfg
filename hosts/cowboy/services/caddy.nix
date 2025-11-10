{
  lib,
  self,
  ...
}: let
  inherit
    (lib)
    attrsToList
    mkMerge
    ;

  enable = true;
in {
  config = {
    networking.firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [80 443];
    };

    services.caddy = {
      inherit enable;

      virtualHosts =
        self.nixosConfigurations.swordsmachine.config.chonkos.services.reverse-proxy.hosts
        |> attrsToList
        |> map ({value, ...}: {
          "https://${value.domain}" = {
            extraConfig = ''
              # Using tailscale
              reverse_proxy http://swordsmachine {
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

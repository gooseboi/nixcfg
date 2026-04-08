{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkForce
    mkIf
    ;

  inherit (config.networking) domain;

  enable = true;
  port = 53842;

  subDomain = "file";
  url = "${subDomain}.${domain}";

  user = "gokapi";
  group = "gokapi";
in {
  config = mkIf enable {
    services.gokapi = {
      enable = true;

      environment = {
        GOKAPI_PORT = port;
      };

      settings = {
        # The trailing / is load-bearing because (I assume) go is a simple language.
        ServerUrl = "https://${url}/";
        RedirectUrl = "https://youtu.be/b2pD0B9Rfps";
      };
    };

    users = {
      users.${user} = {
        inherit group;
        isSystemUser = true;
      };
      groups.${group} = {};
    };

    systemd.services.gokapi = {
      serviceConfig = {
        DynamicUser = mkForce false;
        User = user;
        Group = group;
      };
    };

    services.caddy.virtualHosts."https://${url}" = {
      extraConfig = ''
        reverse_proxy localhost:${toString port} {
        }
      '';
    };
  };
}

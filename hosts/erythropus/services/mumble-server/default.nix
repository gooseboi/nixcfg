{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;

  inherit (config.networking) domain;

  enable = true;
  port = 64738;
  dataDir = "/var/lib/murmur";
  subDomain = "mumble.${domain}";
in {
  config = mkIf enable {
    age.secrets.murmur-envfile.file = ./murmur-envfile.age;

    services.murmur = {
      enable = true;
      port = port;

      stateDir = dataDir;

      openFirewall = true;

      welcometext =
        # html
        "<b>Miau</b>";
      bandwidth = 1 * 1000 * 1000;

      environmentFile = config.age.secrets.murmur-envfile.path;
      password = "$MURMURD_PASSWORD";

      tls = {
        # certPath = "${certPath}/${subDomain}.key";
        # caPath = "${certPath}/${subDomain}.crt";
      };
    };

    # TODO: The problem with using caddy is that I can't point mumble at the
    # certs because it makes the directory only readable by the caddy user, and
    # I'd rather not touch those perms. Therefore, I would prefer having
    # something that uses certbot to auto-renew the certificates, and put them
    # somewhere where mumble can find them.
    # # Possible command: certbot --work-dir letsencrypt/work \
    #         --logs-dir letsencrypt/logs \
    #         --config-dir letsencrypt/config \
    #         certonly \
    #         --domain test.gooseman.net \
    #         --webroot \
    #         --webroot-path /home/chonk/letsencrypt
    # https://eff-certbot.readthedocs.io/en/stable/using.html#certbot-commands

    # This is so caddy auto renews the cert from let's encrypt
    # and I can just copy it from there when needed.
    services.caddy.virtualHosts."https://${subDomain}" = {
      extraConfig = ''
        handle /subpath* {
          root /tmp/mumblecert
          file_server
        }

        handle {
          root ${./html}
          file_server
        }
      '';
    };
  };
}

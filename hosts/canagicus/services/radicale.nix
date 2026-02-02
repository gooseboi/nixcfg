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

  port = 5232;
  dataDir = "/var/lib/radicale";
  subDomain = "cal";

  collectionPath = "${dataDir}/collections";
in {
  config = mkIf enable {
    services.restic.backups.computer = {
      paths = [collectionPath];
      exclude = [
        "${collectionPath}/**/.Radicale.cache"
        "${collectionPath}/.Radicale.lock"
      ];
    };

    # Generate more users with
    # `echo "<pass>" | nix run .\#htpasswd -- -ni -5 user`
    # That will output the required line to put in the htpasswd file to
    # stdout.
    #
    # The files are plain-text and each text line can be just appended
    # together, leaving two trailing newlines at the
    # end. (<line1>\n<line2>\n\n)
    age.secrets.radicale-htpasswd = {
      mode = "400";
      # This isn't documented in the module options but this is the user that
      # the service is run as.
      owner = "radicale";
      file = ./secrets/radicale-htpasswd.age;
    };

    services.radicale = {
      inherit enable;

      settings = {
        server = {
          hosts = [
            "127.0.0.1:${toString port}"
            "[::1]:${toString port}"
          ];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = config.age.secrets.radicale-htpasswd.path;
          htpasswd_encryption = "autodetect";
        };
        storage = {
          filesystem_folder = collectionPath;
        };
      };
    };

    chonkos.services.reverse-proxy.hosts.radicale = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
    };
  };
}

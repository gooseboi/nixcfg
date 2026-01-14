{config, ...}: let
  dataDir = "/var/lib/anki-sync-server";

  inherit (config.networking) domain;

  bindAddress = "127.0.0.1";
  bindPort = 5701;
in {
  age.secrets = {
    anki-chonkpassword = {
      mode = "400";
      owner = "anki-sync-server";
      file = ./secrets/anki-chonkpassword.age;
    };
  };

  services.restic.backups.computer = {
    paths = [dataDir];
  };

  chonkos.services.anki-sync-server = {
    enable = true;
    inherit bindAddress bindPort;
    users = {
      chonk.passwordFile = config.age.secrets.anki-chonkpassword.path;
    };
    stateDir = dataDir;

    hashPasswords = true;
  };

  chonkos.services.reverse-proxy.hosts.anki = {
    target = "http://${bindAddress}:${toString bindPort}";
    targetType = "tcp";
    domain = "anki.${domain}";
  };
}

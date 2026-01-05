{config, ...}: let
  dataDir = "/var/lib/anki-sync-server";
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
    users = {
      chonk.passwordFile = config.age.secrets.anki-chonkpassword.path;
    };
    stateDir = dataDir;

    hashPasswords = true;
  };
}

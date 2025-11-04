{config, ...}: {
  age.secrets = {
    anki-chonkpassword = {
      mode = "600";
      owner = "anki-sync-server";
      file = ./secrets/anki-chonkpassword.age;
    };
  };

  chonkos.services.anki-sync-server = {
    enable = true;
    users = {
      chonk.passwordFile = config.age.secrets.anki-chonkpassword.path;
    };

    hashPasswords = true;
  };
}

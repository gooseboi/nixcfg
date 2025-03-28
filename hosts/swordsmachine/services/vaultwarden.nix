{config, ...}: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";

    environmentFile = config.age.secrets.vaultwarden-envfile.path;
    config = {
      DOMAIN = "https://pass.gooseman.net";
      LOG_FILE = "/var/lib/bitwarden_rs/access.log";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
    };
  };
}

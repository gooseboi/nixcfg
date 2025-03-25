{...}: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
  };
}

let
  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ";
in {
  "modules/secrets/chonk-hashedPassword.age".publicKeys = [publicKey];

  "hosts/swordsmachine/services/secrets/vaultwarden-envfile.age".publicKeys = [publicKey];
  "hosts/swordsmachine/services/secrets/grafana-adminpassword.age".publicKeys = [publicKey];
  "hosts/swordsmachine/secrets/freedns-token.age".publicKeys = [publicKey];
}

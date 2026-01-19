let
  inherit (import ./keys.nix) chonk anatidae canagicus printer all;
in {
  "modules/secrets/chonk-hashedPassword.age".publicKeys = all;

  "hosts/anatidae/syncthing-cert.age".publicKeys = [anatidae chonk];
  "hosts/anatidae/syncthing-key.age".publicKeys = [anatidae chonk];

  "hosts/canagicus/restic/restic-password.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/restic/restic-envfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/secrets/freedns-token.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/anki-chonkpassword.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/grafana-adminpassword.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/linkwarden-envfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/miniflux-admincredentials.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/miniflux-metricspassword.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/miniflux-metricsusername.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/readeck-envfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/vaultwarden-envfile.age".publicKeys = [canagicus chonk];
}

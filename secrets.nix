let
  inherit
    (import ./keys.nix)
    chonk
    canagicus
    erythropus
    indicus
    all
    ;
in {
  "modules/secrets/chonk-hashedPassword.age".publicKeys = all;

  "hosts/canagicus/restic/restic-envfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/restic/restic-password.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/secrets/freedns-token.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/anki-chonkpassword.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/grafana-adminpassword.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/grafana-secretkey.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/linkwarden-envfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/miniflux-admincredentials.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/miniflux-metricspassword.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/miniflux-metricsusername.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/radicale-htpasswd.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/readeck-envfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/suwayomi-server-passwordfile.age".publicKeys = [canagicus chonk];
  "hosts/canagicus/services/secrets/vaultwarden-envfile.age".publicKeys = [canagicus chonk];

  "hosts/erythropus/services/mumble-server/murmur-envfile.age".publicKeys = [erythropus chonk];

  "hosts/indicus/syncthing-cert.age".publicKeys = [indicus chonk];
  "hosts/indicus/syncthing-key.age".publicKeys = [indicus chonk];
}

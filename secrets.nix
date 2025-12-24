let
  inherit (import ./keys.nix) chonk anatidae swordsmachine printer all;
in {
  "modules/secrets/chonk-hashedPassword.age".publicKeys = all;

  "hosts/anatidae/syncthing-cert.age".publicKeys = [anatidae chonk];
  "hosts/anatidae/syncthing-key.age".publicKeys = [anatidae chonk];

  "hosts/swordsmachine/secrets/freedns-token.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/services/secrets/anki-chonkpassword.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/services/secrets/grafana-adminpassword.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/services/secrets/miniflux-admincredentials.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/services/secrets/readeck-envfile.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/services/secrets/vaultwarden-envfile.age".publicKeys = [swordsmachine chonk];
}

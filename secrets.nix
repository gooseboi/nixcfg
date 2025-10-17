let
  inherit (import ./keys.nix) chonk anatidae swordsmachine printer all;
in {
  "modules/secrets/chonk-hashedPassword.age".publicKeys = all;

  "hosts/anatidae/syncthing-cert.age".publicKeys = [anatidae chonk];
  "hosts/anatidae/syncthing-key.age".publicKeys = [anatidae chonk];

  "hosts/swordsmachine/services/secrets/vaultwarden-envfile.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/services/secrets/grafana-adminpassword.age".publicKeys = [swordsmachine chonk];
  "hosts/swordsmachine/secrets/freedns-token.age".publicKeys = [swordsmachine chonk];
}

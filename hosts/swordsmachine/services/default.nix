{...}: {
  imports = [
    ./caddy.nix
    ./ferdium.nix
    ./forgejo.nix
    ./vaultwarden.nix
  ];

  virtualisation.oci-containers.backend = "podman";

  age.secrets.vaultwarden-envfile.file = ./secrets/vaultwarden-envfile.age;
}

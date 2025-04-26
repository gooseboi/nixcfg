{
  # TODO: Immich (https://immich.app/)
  # TODO: Radarr, Sonarr (https://wiki.servarr.com/radarr)
  # TODO: Syncserver (https://github.com/mozilla-services/syncstorage-rs)
  # TODO: Prometheus, Grafana (https://github.com/rgbcube/ncc/blob/5125a31e7f613943e83696814a223b7d2a1c5191/hosts/best/grafana/default.nix)
  # TODO: Anubis (https://anubis.techaro.lol)
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = [
    ./caddy.nix
    ./ferdium.nix
    ./forgejo.nix
    ./stirling-pdf.nix
    ./vaultwarden.nix
  ];

  virtualisation.oci-containers.backend = "podman";

  age.secrets.vaultwarden-envfile.file = ./secrets/vaultwarden-envfile.age;
}

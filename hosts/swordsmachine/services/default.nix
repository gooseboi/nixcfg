{
  # TODO: Immich (https://immich.app/)
  # TODO: Radarr, Sonarr (https://wiki.servarr.com/radarr)
  # TODO: Murmur (https://github.com/mumble-voip/mumble)
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = [
    ./anki-sync-server.nix
    ./caddy.nix
    ./ferdium.nix
    ./forgejo.nix
    ./grafana.nix
    ./prometheus.nix
    ./radicale.nix
    ./readeck.nix
    ./rss-proxy.nix
    ./stirling-pdf.nix
    ./suwayomi-server.nix
    ./vaultwarden.nix
  ];

  chonkos.services.postgresql = {
    enable = true;
    version = 17;
  };

  virtualisation.oci-containers.backend = "podman";
}

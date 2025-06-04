{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.services;
in {
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
    ./suwayomi-server.nix
    ./vaultwarden.nix
  ];

  assertions = [
    {
      assertion =
        cfg
        |> lib.attrValues
        |> lib.filter (srv: srv.enableReverseProxy)
        |> map (srv: srv.servicePort)
        |> (v: v == lib.unique v);
      message = "Two services cannot share the same port";
    }
  ];

  virtualisation.oci-containers.backend = "podman";

  age.secrets.vaultwarden-envfile.file = ./secrets/vaultwarden-envfile.age;
}

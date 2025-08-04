{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.services;
in {
  # TODO: Immich (https://immich.app/)
  # TODO: Radarr, Sonarr (https://wiki.servarr.com/radarr)
  # TODO: Murmur (https://github.com/mumble-voip/mumble)
  # TODO: Prometheus, Grafana (https://github.com/rgbcube/ncc/blob/5125a31e7f613943e83696814a223b7d2a1c5191/hosts/best/grafana/default.nix)
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = [
    ./caddy.nix
    ./ferdium.nix
    ./forgejo.nix
    ./radicale.nix
    ./stirling-pdf.nix
    ./suwayomi-server.nix
    ./vaultwarden.nix
  ];

  assertions = [
    {
      assertion =
        cfg
        |> lib.attrValues
        |> lib.filter (srv: srv.enable)
        |> lib.filter (srv: builtins.hasAttr "port" srv)
        |> map (srv: srv.port)
        |> (v: v == lib.unique v);
      message = "Two services cannot share the same port";
    }
  ];

  chonkos.services = {
    ferdium.enable = true;
    forgejo.enable = true;
    radicale.enable = true;
    stirling-pdf.enable = true;
    suwayomi-server.enable = true;
    vaultwarden.enable = true;
  };

  virtualisation.oci-containers.backend = "podman";

  age.secrets.vaultwarden-envfile.file = ./secrets/vaultwarden-envfile.age;
}

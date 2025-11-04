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
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = [
    ./anki-sync-server.nix
    ./caddy.nix
    ./ferdium.nix
    ./forgejo.nix
    ./grafana.nix
    ./prometheus.nix
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
        |> lib.filter (srv: srv.enable or false)
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

    grafana.enable = true;
    prometheus.enable = true;
  };

  virtualisation.oci-containers.backend = "podman";

  age.secrets = {
    vaultwarden-envfile.file = ./secrets/vaultwarden-envfile.age;
    grafana-adminpassword = {
      mode = "600";
      # This isn't documented in the module options but this is the user
      # that the service is run as.
      owner = "grafana";
      file = ./secrets/grafana-adminpassword.age;
    };
  };
}

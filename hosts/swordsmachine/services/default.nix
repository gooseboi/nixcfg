{lib, ...}: let
  inherit
    (lib)
    listNix
    remove
    ;
in {
  # TODO: Immich (https://immich.app/)
  # TODO: Radarr, Sonarr (https://wiki.servarr.com/radarr)
  # TODO: Murmur (https://github.com/mumble-voip/mumble)
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = listNix ./. |> remove ./default.nix;

  chonkos.services.postgresql = {
    enable = true;
    version = 17;
  };

  virtualisation.oci-containers.backend = "podman";
}

{lib, ...}: let
  inherit
    (lib)
    listNix
    remove
    ;
in {
  # TODO: Immich (https://immich.app/)
  # TODO: Radarr, Sonarr (https://wiki.servarr.com/radarr)
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = listNix ./. |> remove ./default.nix;

  virtualisation.oci-containers.backend = "podman";
}

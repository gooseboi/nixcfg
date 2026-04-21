{lib, ...}: let
  inherit
    (lib)
    listNixWithDirs
    remove
    ;
in {
  # TODO: Immich (https://immich.app/)
  # TODO: Radarr, Sonarr (https://wiki.servarr.com/radarr)
  # TODO: Paperless-ngx (https://docs.paperless-ngx.com)

  imports = listNixWithDirs ./. |> remove ./default.nix;

  virtualisation.oci-containers.backend = "podman";
}

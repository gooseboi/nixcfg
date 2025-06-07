{lib, ...}: let
  inherit (lib) listNixWithDirs remove;
in {
  imports = listNixWithDirs ./. |> remove ./default.nix;
}

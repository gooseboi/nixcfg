{lib, ...}: let
  inherit (lib) listNixWithDirs remove;
in {
  imports = listNixWithDirs ./. |> remove ./default.nix;

  options.chonkos = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) listNixWithDirs remove mkValue;
in {
  imports = listNixWithDirs ./. |> remove ./default.nix;

  options.chonkos = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };

    type = lib.mkOption {
      type = lib.types.str;
      example = "desktop";
      description = "the type of the machine";
      readOnly = true;
    };

    isDesktop = mkValue (config.chonkos.type == "desktop");
    isServer = mkValue (config.chonkos.type == "server");
  };
}

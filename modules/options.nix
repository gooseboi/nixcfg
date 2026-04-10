{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkValue
    types
    ;
in {
  options.chonkos = {
    user = mkOption {
      type = types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };

    type = mkOption {
      type = types.str;
      example = "desktop";
      description = "the type of the machine";
      readOnly = true;
    };

    isDesktop = mkValue (config.chonkos.type == "desktop");
    isServer = mkValue (config.chonkos.type == "server");
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) elem mkOption types;

  cfg = config.chonkos.unfree;
in {
  options.chonkos.unfree = {
    allowed = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "list of packages to add to unfreelist";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: elem pkg.pname cfg.allowed;
  };
}

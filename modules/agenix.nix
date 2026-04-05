{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkDisableOption
    mkIf
    ;

  cfg = config.chonkos.agenix;
in {
  options.chonkos.agenix = {
    enable = mkDisableOption "enable agenix support";
  };

  config = mkIf cfg.enable {
    age.identityPaths = [
      "/root/.ssh/id"
    ];
    environment.systemPackages = [pkgs.agenix];
  };
}

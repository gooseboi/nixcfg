{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.agenix;
in {
  options.chonkos.agenix = {
    enable = mkEnableOption "enable agenix support";
  };

  config = mkIf cfg.enable {
    age.identityPaths = [
      "/root/.ssh/id"
    ];
    environment.systemPackages = [pkgs.agenix];
  };
}

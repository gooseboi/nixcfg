{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.agenix;
in {
  options.chonkos.agenix = {
    enable = lib.mkEnableOption "enable agenix support";
  };

  config = lib.mkIf cfg.enable {
    age.identityPaths = [
      "/root/.ssh/id"
    ];
    environment.systemPackages = [pkgs.agenix];
  };
}

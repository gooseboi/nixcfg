{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkBoolOption
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.mpv;
in {
  options.chonkos.mpv = {
    enable = mkBoolOption "enable mpv" isDesktop;
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables.VIDEO = "mpv";
      systemPackages = with pkgs; [
        mpv
      ];
    };
  };
}

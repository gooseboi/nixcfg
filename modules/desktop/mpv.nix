{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.chonkos.desktop;
in {
  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        home.sessionVariables = {
          VIDEO = "mpv";
        };
      }
    ];

    environment.systemPackages = with pkgs; [
      mpv
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkIf
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.cursor;
in {
  options.chonkos.cursor = {
    enable = mkBoolOption "enable cursor config" isDesktop;
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        home.pointerCursor = {
          enable = true;
          package = pkgs.bibata-cursors;
          size = 24;
          name = "Bibata-Original-Classic";

          dotIcons.enable = false;
          hyprcursor.enable = true;
          x11.enable = true;
          gtk.enable = true;
        };
      }
    ];
  };
}

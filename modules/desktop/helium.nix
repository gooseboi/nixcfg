{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    strings
    types
    ;

  cfg = config.chonkos.desktop.helium;
in {
  options.chonkos.desktop.helium = {
    enable = mkOption {
      description = "enable helium installation";
      type = types.bool;
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.chromium = let
          enabledFeatures = [
            # Scrolling left/right goes back/forward in history
            "TouchpadOverscrollHistoryNavigation"
          ];
          enabledFeaturesStr = strings.concatStringsSep "," enabledFeatures;
        in {
          enable = true;
          package = pkgs.helium;
          commandLineArgs = [
            "--password-store=basic"
            "--enable-features=${enabledFeaturesStr}"
          ];
        };
      }
    ];
  };
}

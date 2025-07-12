{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf strings;

  cfg = config.chonkos.desktop;
in {
  config = mkIf cfg.enable {
    environment.etc."/brave/policies/managed/GroupPolicy.json".source = ./brave-policies.json;

    home-manager.sharedModules = [
      {
        programs.chromium = let
          enabledFeatures = ["TouchpadOverscrollHistoryNavigation"];
          enabledFeaturesStr = strings.concatStringsSep "," enabledFeatures;
        in {
          enable = true;
          package = pkgs.brave;
          commandLineArgs = [
            "--password-store=basic"
            "--enable-features=${enabledFeaturesStr}"
          ];
        };
      }
    ];
  };
}

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

  cfg = config.chonkos.desktop.brave;
in {
  options.chonkos.desktop.brave = {
    enable = mkOption {
      description = "enable brave installation";
      type = types.bool;
      default = config.chonkos.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    environment.etc."/brave/policies/managed/GroupPolicy.json".text =
      builtins.toJSON
      {
        BraveAIChatEnabled = false;
        BraveRewardsDisabled = true;
        BraveWalletDisabled = true;
        BraveVPNDisabled = true;
        AutoplayAllowed = false;
      };

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

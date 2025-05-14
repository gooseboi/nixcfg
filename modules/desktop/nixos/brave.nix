{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.desktop;
in {
  config = lib.mkIf cfg.enable {
    environment.etc."/brave/policies/managed/GroupPolicy.json".source = ./brave-policies.json;

    home-manager.sharedModules = [
      {
        programs.chromium = {
          enable = true;
          package = pkgs.brave;
          commandLineArgs = ["--password-store=basic" "--enable-features=TouchpadOverscrollHistoryNavigation"];
        };
      }
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkPackageOption;

  cfg = config.chonkos.nushell;
in {
  options.chonkos.nushell = {
    enable = mkEnableOption "enable nushell";
    enableUserShell = mkEnableOption "enable setting as default shell";
    package = mkPackageOption pkgs "nushell" {};
  };

  config = mkIf cfg.enable {
    environment = {
      shells = [
        "/run/current-system/sw/bin/nu"
        "${cfg.package}/bin/nu"
      ];

      systemPackages = [cfg.package];
    };

    users.users.${config.chonkos.user} = lib.mkIf cfg.enableUserShell {
      shell = cfg.package;
    };

    home-manager.sharedModules = [
      {
        programs.nushell = {
          enable = true;

          inherit (cfg) package;
        };
      }
    ];
  };
}

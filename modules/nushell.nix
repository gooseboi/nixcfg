{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    mkEnableOption
    mkIf
    mkPackageOption
    ;

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
        "${getExe cfg.package}"
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

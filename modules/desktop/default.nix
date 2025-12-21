{
  config,
  lib,
  ...
}: let
  inherit (config.chonkos) isDesktop;
  inherit
    (lib)
    listNixWithDirs
    mkIf
    mkOption
    remove
    types
    ;

  cfg = config.chonkos.desktop;
in {
  options.chonkos.desktop = {
    enable = mkOption {
      type = types.bool;
      description = "enable desktop configurations";
      default = isDesktop;
    };
  };

  imports = listNixWithDirs ./. |> remove ./default.nix;

  config = mkIf cfg.enable {
    services.upower.enable = true;

    home-manager.sharedModules = [
      {
        config = {
          home.sessionVariables = {
            # Scaling
            QT_AUTO_SCREEN_SCALE_FACTOR = 0;
            QT_SCALE_FACTOR = 1;
            QT_SCREEN_SCALE_FACTORS = "1;1;1";
            GDK_SCALE = 1;
            GDK_DPI_SCALE = 1;
          };
        };
      }
    ];
  };
}

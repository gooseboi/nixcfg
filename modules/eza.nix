{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkDisableOption
    mkIf
    ;

  cfg = config.chonkos.eza;
in {
  options.chonkos.eza = {
    enable = mkDisableOption "enable eza";
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.eza = {
          enable = true;
          icons = "auto";
        };
      }
    ];
  };
}

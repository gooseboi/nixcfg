{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.chonkos.eza = {
    enable = mkEnableOption "enable eza";
  };

  config = mkIf config.chonkos.eza.enable {
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

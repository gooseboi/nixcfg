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

  config.programs.eza = mkIf config.chonkos.eza.enable {
    enable = true;
    icons = "auto";
  };
}

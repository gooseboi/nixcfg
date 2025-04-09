{
  pkgs,
  lib,
  config,
  ...
}: {
  options.chonkos.eza = {
    enable = lib.mkEnableOption "enable eza";
  };

  config.programs.eza = lib.mkIf config.chonkos.eza.enable {
    enable = true;
    icons = "auto";
  };
}

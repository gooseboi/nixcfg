{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.hyprland;
in {
  options.chonkos.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    hardware = {
      graphics.enable = true;
    };

    programs.light.enable = true;
  };
}

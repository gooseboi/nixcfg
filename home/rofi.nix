{
  config,
  lib,
  pkgs,
  systemConfig,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (systemConfig.chonkos) theme;

  cfg = config.chonkos.rofi;
in {
  options.chonkos.rofi = {
    enable = mkEnableOption "enable rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      plugins = [pkgs.rofi-emoji];

      theme = "gruvbox-dark-hard";
      extraConfig = with theme.font; {
        modi = "window,drun,ssh,run,emoji";
        font = "${sans.name} ${builtins.toString size.big}";
        m = "-1";
      };
    };
  };
}

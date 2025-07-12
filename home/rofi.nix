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
    useXorg = mkEnableOption "whether to use rofi-wayland or not";
  };
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package =
        if cfg.useXorg
        then pkgs.rofi
        else pkgs.rofi-wayland;

      plugins =
        if cfg.useXorg
        then (with pkgs; [rofi-emoji])
        else (with pkgs; [rofi-emoji-wayland]);

      theme = "gruvbox-dark-hard";
      extraConfig = with theme.font; {
        modi = "window,drun,ssh,run,emoji";
        font = "${sans.name} ${builtins.toString size.big}";
        m = "-1";
      };
    };
  };
}

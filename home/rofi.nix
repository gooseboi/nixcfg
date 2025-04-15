{
  config,
  lib,
  pkgs,
  systemConfig,
  ...
}: let
  inherit (systemConfig.chonkos) theme;

  cfg = config.chonkos.rofi;
in {
  options.chonkos.rofi = {
    enable = lib.mkEnableOption "enable rofi";
    useXorg = lib.mkEnableOption "whether to use rofi-wayland or not";
  };
  config = lib.mkIf cfg.enable {
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

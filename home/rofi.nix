{
  pkgs,
  lib,
  config,
  ...
}: let
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
      extraConfig = {
        modi = "window,drun,ssh,run,emoji";
        font = "hack 10";
        m = "-1";
      };
    };

    home.packages = with pkgs; [nerd-fonts.hack];
  };
}

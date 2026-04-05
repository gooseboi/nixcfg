{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.chonkos) theme;

  cfg = config.chonkos.rofi;
in {
  options.chonkos.rofi = {
    enable = mkEnableOption "enable rofi";
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.rofi = {
          enable = true;
          package = pkgs.rofi;

          plugins = [pkgs.rofi-emoji];

          theme = "gruvbox-dark-hard";
          extraConfig = with theme.font; {
            modi = "window,drun,ssh,run,emoji";
            font = "${sans.name} ${toString size.big}";
            m = "-1";
          };
        };
      }
    ];
  };
}

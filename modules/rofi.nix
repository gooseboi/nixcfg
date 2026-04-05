{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkIf
    ;

  inherit
    (config.chonkos)
    isDesktop
    theme
    ;

  cfg = config.chonkos.rofi;
in {
  options.chonkos.rofi = {
    enable = mkBoolOption "enable rofi" isDesktop;
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

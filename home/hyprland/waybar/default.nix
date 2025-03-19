{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.chonkos.hyprland.enable {
    home.packages = with pkgs; [
      font-awesome # The bar's font
      procps # Start script
      findutils # Start script (xargs)
      gawk # Start script
      gnugrep # Start script
    ];

    programs.waybar = {
      enable = true;

      style = ./style.css;
    };

    xdg.configFile."waybar/waybar.sh" = {
      source = ./waybar.sh;
      executable = true;
    };
    xdg.configFile."waybar/config.jsonc" = {
      source = ./config.jsonc;
    };
  };
}

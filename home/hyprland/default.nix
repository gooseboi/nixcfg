{
  pkgs,
  config,
  lib,
  ...
}: {
  options.chonkos.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
    enableMpd = lib.mkEnableOption "enable mpd support";
    enableDebug = lib.mkEnableOption "enable debug logs";
  };

  config = lib.mkIf config.chonkos.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        debug.disable_logs = !config.chonkos.hyprland.enableDebug;

        exec-once = [
          "${pkgs.networkmanagerapplet}/bin/nm-applet"
          "${pkgs.blueman}/bin/blueman-applet"
          "${pkgs.util-linux}/bin/rfkill block bluetooth"
          "${pkgs.dunst}/bin/dunst"
          (lib.optionalString config.chonkos.hyprland.enableMpd "${pkgs/mpd}/bin/mpd")
          "${pkgs.swayidle}/bin/swayidle -w before-sleep 'hyprland-before-sleep.sh'"
        ];
      };

      extraConfig = builtins.readFile ./hyprland.conf;
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.packages = with pkgs; [
      killall # For waybar start script
    ];

    programs.waybar = {
      enable = true;

      style = ./waybar/style.css;
    };

    # TODO: Use xdg config dir instead
    home.file.".config/waybar/waybar.sh" = {
      source = ./waybar/waybar.sh;
      executable = true;
    };
    home.file.".config/waybar/config.jsonc" = {
      source = ./waybar/config.jsonc;
    };
  };
}

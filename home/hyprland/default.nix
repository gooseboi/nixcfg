{
  pkgs,
  config,
  lib,
  systemConfig,
  ...
}: let
  cfg = config.chonkos.hyprland;
in {
  options.chonkos.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
    enableMpd = lib.mkEnableOption "enable mpd support";
    enableDebug = lib.mkEnableOption "enable debug logs";
  };

  config = lib.mkIf cfg.enable {
    chonkos.desktop.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        debug.disable_logs = !cfg.enableDebug;

        exec-once = [
          (lib.optionalString systemConfig.chonkos.network-manager.enable "${pkgs.networkmanagerapplet}/bin/nm-applet")
          "${pkgs.blueman}/bin/blueman-applet"
          "${pkgs.util-linux}/bin/rfkill block bluetooth"
          "${pkgs.dunst}/bin/dunst"
          (lib.optionalString cfg.enableMpd "${pkgs/mpd}/bin/mpd")
          "${pkgs.swayidle}/bin/swayidle -w before-sleep 'hyprland-before-sleep.sh'"
        ];
      };

      extraConfig = builtins.readFile ./hyprland.conf;
    };

    xdg.portal = {
      enable = true;
      config.common.default = "*";

      configPackages = [
        pkgs.hyprland
      ];

      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.packages = with pkgs; [
      # For waybar
      font-awesome # The bar's font
      procps # Start script
      findutils # Start script (xargs)
      gawk # Start script
      gnugrep # Start script
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

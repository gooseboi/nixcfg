{
  pkgs,
  config,
  lib,
  systemConfig,
  ...
}: let
  cfg = config.chonkos.hyprland;
  nmEnabled = systemConfig.chonkos.network-manager.enable;
in {
  imports = [
    ./waybar
  ];

  options.chonkos.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
    enableMpd = lib.mkEnableOption "enable mpd support";
    enableDebug = lib.mkEnableOption "enable debug logs";
  };

  config = lib.mkIf cfg.enable {
    chonkos.desktop.enable = true;

    home.packages = lib.lists.optional nmEnabled pkgs.networkmanagerapplet;

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      size = 24;
      name = "Bibata-Original-Classic";

      hyprcursor.enable = true;
      x11.enable = true;
      gtk.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        debug.disable_logs = !cfg.enableDebug;

        exec-once = [
          (lib.optionalString nmEnabled "nm-applet")
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
  };
}

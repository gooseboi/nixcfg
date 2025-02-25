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

    programs.waybar = {
      enable = true;

      # Both of these are mostly stolen from
      # https://gitlab.com/librephoenix/nixos-config/ with some small changes for me
      #
      # Cool dude
      style = ./waybar/style.css;
      # TODO: Fix this
      #settings = builtins.fromJSON (builtins.readFile ./waybar/config.json);
    };
  };
}

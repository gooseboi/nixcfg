{
  lib,
  systemConfig,
  ...
}: let
  inherit (systemConfig.chonkos) theme;

  colours = theme.withHashtag;

  cfg = systemConfig.chonkos.hyprland;
in {
  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      iconTheme = {
        inherit (theme.icons) name package;
        size = "32x32";
      };

      settings.global = {
        width = "(200, 1100)";

        corner_radius = 4;
        gap_size = 0;
        horizontal_padding = 8;
        padding = 8;

        frame_color = colours.base0A;
        frame_width = 2;
        separator_color = "frame";

        background = colours.base00;
        foreground = colours.base05;

        alignment = "left";
        font = "${theme.font.sans.name} ${toString theme.font.size.normal}";

        min_icon_size = 64;

        offset = "0x0";
        origin = "top-right";
      };

      settings.urgency_low = {
        frame_color = colours.base0A;
        timeout = 5;
      };

      settings.urgency_normal = {
        frame_color = colours.base09;
        timeout = 10;
      };

      settings.urgency_critical = {
        frame_color = colours.base08;
        timeout = 15;
      };
    };
  };
}

{
  lib,
  pkgs,
  systemConfig,
  ...
}: let
  inherit (systemConfig.chonkos) theme;

  mkMenu = name: menu: let
    configFile =
      pkgs.writeText "wlr_which_key-${name}-config.yaml"
      (pkgs.lib.generators.toYAML {} {
        # Theming
        font = "${theme.font.mono.name} ${toString theme.font.size.big}";
        background = "${theme.withHashtagLower.base00}d0";
        color = "${theme.withHashtagLower.base05}";
        border = "${theme.withHashtagLower.base0A}";
        separator = " ➜ ";
        border_width = 2;
        corner_r = 10;
        padding = 15;
        rows_per_column = 5;
        column_padding = 25;

        # Anchor and margin
        anchor = "center";
        margin_right = 0;
        margin_bottom = 0;
        margin_left = 0;
        margin_top = 0;

        inhibit_compositor_keyboard_shortcuts = true;

        # Try to guess the correct keyboard layout to use. Default is `false`.
        auto_kbd_layout = true;

        inherit menu;
      });
  in
    pkgs.writeShellScriptBin "my-menu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';
in {
  config.wayland.windowManager.hyprland = {
    settings = {
      bind = let
        menuShutdown = mkMenu "shutdown" [
          {
            key = "s";
            desc = "Sleep";
            cmd = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
          }
          {
            key = "r";
            desc = "Reboot";
            cmd = "${lib.getExe' pkgs.systemd "reboot"}";
          }
          {
            key = "p";
            desc = "Poweroff";
            cmd = "${lib.getExe' pkgs.systemd "poweroff"}";
          }
        ];
        menuUtils = mkMenu "utils" [
          {
            key = "n";
            desc = "Toggle notifications";
            cmd = "${lib.getExe' pkgs.dunst "dunstctl"} set-paused toggle";
          }
        ];
      in [
        "SHIFTSUPER, S, exec, ${lib.getExe menuShutdown}"
        "SHIFTSUPER, U, exec, ${lib.getExe menuUtils}"
      ];
    };
  };
}

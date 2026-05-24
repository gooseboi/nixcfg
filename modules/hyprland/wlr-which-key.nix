{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    ;

  inherit
    (lib.generators)
    mkLuaInline
    ;

  inherit
    (lib.strings)
    escapeShellArg
    ;

  inherit (config.chonkos) theme;

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
      exec ${getExe pkgs.wlr-which-key} ${configFile}
    '';
in {
  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland = {
        settings = {
          bind = let
            youSureSubMenu = cmd: [
              {
                key = "y";
                desc = "Yes";
                inherit cmd;
              }
              {
                key = "n";
                desc = "No";
                cmd = "";
              }
            ];
            menuShutdown = mkMenu "shutdown" [
              {
                key = "s";
                desc = "Sleep";
                submenu = youSureSubMenu "${getExe' pkgs.systemd "systemctl"} suspend";
              }
              {
                key = "r";
                desc = "Reboot";
                submenu = youSureSubMenu "${getExe' pkgs.systemd "reboot"}";
              }
              {
                key = "p";
                desc = "Poweroff";
                submenu = youSureSubMenu "${getExe' pkgs.systemd "poweroff"}";
              }
            ];
            menuUtils = mkMenu "utils" [
              {
                key = "n";
                desc = "Toggle notifications";
                cmd = "${getExe' pkgs.dunst "dunstctl"} set-paused toggle";
              }
            ];
            menuConfig = let
              toggleCmd = value: escapeShellArg "hl.config({input = { touchpad = { disable_while_typing = ${value} } } })";
            in
              mkMenu "config"
              [
                {
                  key = "t";
                  desc = "Toggle touchpad while typing";
                  cmd =
                    pkgs.writeShellScriptBin "toggle_touchpad_typing"
                    # bash
                    ''
                      val=$(${getExe' pkgs.hyprland "hyprctl"} getoption input.touchpad.disable_while_typing -j | ${getExe pkgs.jq} .bool)
                      if [ "$val" = "true" ]; then
                        hyprctl eval ${toggleCmd "false"}
                      else
                        hyprctl eval ${toggleCmd "true"}
                      fi
                    ''
                    |> getExe;
                }
              ];
          in [
            # I don't think the home manager people could have come up with a worse
            # syntax if they tried
            {
              _args = [
                "SUPER + SHIFT + S"
                (mkLuaInline ''hl.dsp.exec_cmd("${getExe menuShutdown}")'')
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + U"
                (mkLuaInline ''hl.dsp.exec_cmd("${getExe menuUtils}")'')
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + O"
                (mkLuaInline ''hl.dsp.exec_cmd("${getExe menuConfig}")'')
              ];
            }
          ];
        };
      };
    }
  ];
}

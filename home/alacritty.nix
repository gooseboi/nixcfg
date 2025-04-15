{
  config,
  lib,
  systemConfig,
  ...
}: let
  inherit (systemConfig.chonkos) theme;

  cfg = config.chonkos.alacritty;
in {
  options.chonkos.alacritty = {
    enable = lib.mkEnableOption "enables alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        colors = {
          indexed_colors = [
            {
              color = "#fe8019";
              index = 16;
            }

            {
              color = "#d65d0e";
              index = 17;
            }

            {
              color = "#3c3836";
              index = 18;
            }

            {
              color = "#504945";
              index = 19;
            }

            {
              color = "#bdae93";
              index = 20;
            }

            {
              color = "#ebdbb2";
              index = 21;
            }
          ];

          bright = {
            black = "#665c54";
            blue = "#83a598";
            cyan = "#8ec07c";
            green = "#b8bb26";
            magenta = "#d3869b";
            red = "#fb4934";
            white = "#fbf1c7";
            yellow = "#fabd2f";
          };

          cursor = {
            cursor = "CellForeground";
            text = "CellBackground";
          };

          normal = {
            black = "#1d2021";
            blue = "#83a598";
            cyan = "#8ec07c";
            green = "#b8bb26";
            magenta = "#d3869b";
            red = "#fb4934";
            white = "#d5c4a1";
            yellow = "#fabd2f";
          };

          primary = {
            background = "#1d2021";
            foreground = "#d5c4a1";
          };
        };

        font = with theme.font; {
          size = size.normal;
          normal.family = mono.name;
        };

        keyboard = {
          bindings = [
            {
              action = "Copy";
              key = "C";
              mods = "Alt";
            }

            {
              action = "Paste";
              key = "P";
              mods = "Alt";
            }

            {
              action = "ScrollPageUp";
              key = "PageUp";
              mode = "~Alt";
              mods = "Shift";
            }

            {
              action = "ScrollPageDown";
              key = "PageDown";
              mode = "~Alt";
              mods = "Shift";
            }

            {
              action = "ScrollHalfPageDown";
              key = "J";
              mods = "Alt";
            }

            {
              action = "ScrollHalfPageUp";
              key = "K";
              mods = "Alt";
            }

            {
              action = "IncreaseFontSize";
              key = "J";
              mods = "Shift|Alt";
            }

            {
              action = "DecreaseFontSize";
              key = "K";
              mods = "Shift|Alt";
            }
          ];
        };

        scrolling.history = 100000;

        window.opacity = 0.9;
      };
    };

    home.sessionVariables.TERMINAL = "alacritty";
  };
}

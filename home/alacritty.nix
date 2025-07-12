{
  config,
  lib,
  systemConfig,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (systemConfig.chonkos) theme;

  cfg = config.chonkos.alacritty;
in {
  options.chonkos.alacritty = {
    enable = mkEnableOption "enables alacritty";
    enableEnvVar = mkEnableOption "enables setting TERMINAL environment variable";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        colors = let
          inherit
            (theme.withHashtag)
            base00
            base01
            base02
            base03
            base04
            base05
            base06
            base07
            base08
            base09
            base0A
            base0B
            base0C
            base0D
            base0E
            base0F
            ;
        in {
          primary = {
            background = base00;
            foreground = base05;
          };

          normal = {
            black = base00;
            blue = base0D;
            cyan = base0C;
            green = base0B;
            magenta = base0E;
            red = base08;
            white = base05;
            yellow = base0A;
          };

          bright = {
            black = base03;
            blue = base04;
            cyan = base0F;
            green = base01;
            magenta = base06;
            red = base09;
            white = base07;
            yellow = base02;
          };

          cursor = {
            cursor = base05;
            text = base00;
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

    home.sessionVariables = mkIf cfg.enableEnvVar {
      TERMINAL = "alacritty";
    };
  };
}

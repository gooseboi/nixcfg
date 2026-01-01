{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    ;

  inherit (config.chonkos) theme;

  cfg = config.chonkos.desktop.swayimg;
in {
  options.chonkos.desktop.swayimg = {
    enable = mkOption {
      description = "enable swayimg installation and config";
      default = config.chonkos.desktop.enable;
    };
  };
  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.swayimg = {
          inherit (cfg) enable;

          # https://github.com/artemsen/swayimg/blob/master/extra/swayimgrc
          settings = {
            general = {
              # Mode at startup
              mode = "viewer";
              # create floating window above the currently focused one
              overlay = "no";
              # Use window decoration
              decoration = "no";
            };

            font = {
              name = theme.font.sans.name;
              size = theme.font.size.big;
            };

            viewer = {
              # Window background color (RGBA)
              window = "#00000000";
              # Background for transparent images (grid/RGBA)
              transparency = "grid";
              # Default image scale (optimal/width/height/fit/fill/real/keep)
              scale = "optimal";
              # Initial image position on the window
              position = "center";
              # Anti-aliasing mode (none/box/bilinear/bicubic/mks13)
              antialiasing = "mks13";
              # Loop image list
              loop = "yes";
              # Number of previously viewed images to store in cache
              history = 5;
              # Number of preloaded images (read ahead)
              preload = 5;
            };

            slideshow = {
              # Slideshow image display time (seconds)
              time = 3;
              # Window background color (auto/extend/mirror/RGBA)
              window = "auto";
              # Background for transparent images (grid/RGBA)
              transparency = "#000000ff";
              # Default image scale (optimal/width/height/fit/fill/real)
              scale = "fit";
              # Initial image position on the window (center/top/bottom/free/...)
              position = "center";
              # Anti-aliasing mode (none/box/bilinear/bicubic/mks13)
              antialiasing = "mks13";
            };

            "keys.viewer" = {
              F1 = "help";

              # File navigation
              Home = "first_file";
              End = "last_file";
              Prior = "prev_file";
              Next = "next_file";
              Space = "next_file";
              "Shift+j" = "next_file";
              "Shift+k" = "prev_file";
              "Shift+r" = "rand_file";

              "Shift+o" = "prev_frame";
              o = "next_frame";
              n = "animation";
              f = "fullscreen";
              Left = "step_left 10";
              Right = "step_right 10";
              Up = "step_up 10";
              Down = "step_down 10";

              # Modes
              s = "mode slideshow";
              Return = "mode gallery";

              # Zoom
              Equal = "zoom +10";
              Plus = "zoom +10";
              # When pressing "Shift+Equal", I get this? What?
              "Shift+Plus" = "zoom +10";
              Minus = "zoom -10";
              w = "zoom width";
              "Shift+w" = "zoom height";
              z = "zoom fit";
              "Shift+z" = "zoom fill";
              "Alt+z" = "zoom";

              # Image manipulation
              "Alt+p" = "position";
              bracketleft = "rotate_left";
              bracketright = "rotate_right";
              m = "flip_vertical";
              "Shift+m" = "flip_horizontal";
              "h" = "step_left 5";
              "j" = "step_down 5";
              "k" = "step_up 5";
              "l" = "step_right 5";
              a = "antialiasing";
              r = "reload";
              i = "info";

              # I never want to delete images from my image viewer
              "Shift+Delete" = "none";

              # Leaving
              Escape = "exit";
              q = "exit";

              # Mouse
              ScrollLeft = "step_right 5";
              ScrollRight = "step_left 5";
              ScrollUp = "step_up 5";
              ScrollDown = "step_down 5";
              "Ctrl+ScrollUp" = "zoom +10 mouse";
              "Ctrl+ScrollDown" = "zoom -10 mouse";
              "Shift+ScrollUp" = "prev_file";
              "Shift+ScrollDown" = "next_file";
              "Alt+ScrollUp" = "prev_frame";
              "Alt+ScrollDown" = "next_frame";
              MouseLeft = "drag";
              MouseSide = "prev_file";
              MouseExtra = "next_file";
            };
          };
        };
      }
    ];
  };
}

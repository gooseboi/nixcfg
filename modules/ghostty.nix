{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mapAttrsToList
    mkEnableOption
    mkBoolOption
    mkIf
    ;
  inherit
    (config.chonkos)
    isDesktop
    theme
    ;

  cfg = config.chonkos.ghostty;
in {
  options.chonkos.ghostty = {
    enable = mkBoolOption "enables ghostty" isDesktop;
    enableEnvVar = mkEnableOption "enables setting TERMINAL environment variable";
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.ghostty = {
          enable = true;

          systemd.enable = true;

          clearDefaultKeybinds = true;

          settings =
            {
              font-size = theme.font.size.normal;
              font-family = theme.font.mono.name;

              confirm-close-surface = false;
              gtk-single-instance = true;
              quit-after-last-window-closed = false;

              background-opacity = 0.9;

              keybind = (
                {
                  page_down = "scroll_page_fractional:1";
                  page_up = "scroll_page_fractional:-1";

                  "alt+n" = "new_tab";
                  "alt+x" = "close_tab";
                  "alt+1" = "goto_tab:1";
                  "alt+2" = "goto_tab:2";
                  "alt+3" = "goto_tab:3";
                  "alt+4" = "goto_tab:4";
                  "alt+5" = "goto_tab:5";
                  "alt+6" = "goto_tab:6";
                  "alt+7" = "goto_tab:7";
                  "alt+8" = "goto_tab:8";
                  "alt+9" = "goto_tab:9";

                  "alt+c" = "copy_to_clipboard";
                  "alt+p" = "paste_from_clipboard";

                  "alt+down" = "scroll_page_fractional:1";
                  "alt+up" = "scroll_page_fractional:-1";
                  "alt+j" = "scroll_page_fractional:0.5";
                  "alt+k" = "scroll_page_fractional:-0.5";
                  "alt+home" = "scroll_to_top";
                  "alt+end" = "scroll_to_bottom";

                  "alt+plus" = "increase_font_size:1";
                  "alt+minus" = "decrease_font_size:1";
                  "alt+shift+k" = "increase_font_size:1";
                  "alt+shift+j" = "decrease_font_size:1";
                  "alt+shift+enter" = "reset_font_size";
                }
                |> (mapAttrsToList (name: value: "${name}=${value}"))
              );
            }
            // (with theme.withHashtag; {
              background = base00;
              foreground = base05;

              selection-background = base02;
              selection-foreground = base00;

              palette = [
                "0=${base00}"
                "1=${base08}"
                "2=${base0B}"
                "3=${base0A}"
                "4=${base0D}"
                "5=${base0E}"
                "6=${base0C}"
                "7=${base05}"
                "8=${base03}"
                "9=${base08}"
                "10=${base0B}"
                "11=${base0A}"
                "12=${base0D}"
                "13=${base0E}"
                "14=${base0C}"
                "15=${base07}"
                "16=${base09}"
                "17=${base0F}"
                "18=${base01}"
                "19=${base02}"
                "20=${base04}"
                "21=${base06}"
              ];
            });
        };

        home.sessionVariables = mkIf cfg.enableEnvVar {
          TERMINAL = "ghostty";
        };
      }
    ];
  };
}

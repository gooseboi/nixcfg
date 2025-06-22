{
  config,
  lib,
  systemConfig,
  ...
}: let
  inherit (lib) mapAttrsToList mkEnableOption mkIf;
  inherit (systemConfig.chonkos) theme;

  cfg = config.chonkos.ghostty;
in {
  options.chonkos.ghostty = {
    enable = mkEnableOption "enables ghostty";
    enableEnvVar = mkEnableOption "enables setting TERMINAL environment variable";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      clearDefaultKeybinds = true;

      settings =
        {
          font-size = theme.font.size.normal;
          font-family = theme.font.mono.name;

          confirm-close-surface = false;
          quit-after-last-window-closed = true;
          window-decoration = false;

          keybind =
            [] # For alignment
            ++ (mapAttrsToList (name: value: "${name}=${value}") {
              page_down = "scroll_page_fractional:1";
              page_up = "scroll_page_fractional:-1";
            })
            ++ (mapAttrsToList (name: value: "alt+${name}=${value}") {
              c = "copy_to_clipboard";
              p = "paste_from_clipboard";

              down = "scroll_page_fractional:1";
              j = "scroll_page_fractional:0.5";

              up = "scroll_page_fractional:-1";
              k = "scroll_page_fractional:-0.5";

              home = "scroll_to_top";
              end = "scroll_to_bottom";

              plus = "increase_font_size:1";
              minus = "decrease_font_size:1";
            })
            ++ (mapAttrsToList (name: value: "alt+shift+${name}=${value}") {
              k = "increase_font_size:1";

              enter = "reset_font_size";
              q = "close_surface";
              j = "decrease_font_size:1";
            })
            ++ (mapAttrsToList (name: value: "ctrl+alt+${name}=${value}") {
              j = "scroll_page_lines:1";
              k = "scroll_page_lines:-1";
            });
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
  };
}

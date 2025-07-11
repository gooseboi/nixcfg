{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.chonkos.zathura = {
    enable = mkEnableOption "enable zathura";
  };

  config.programs.zathura = mkIf config.chonkos.zathura.enable {
    enable = true;

    mappings = {
      "<S-k>" = "scroll half-up";
      "<S-j>" = "scroll half-down";
      "<C-h>" = "nohlsearch";
      "D" = "toggle_page_mode";
      "r" = "reload";
      "R" = "rotate";
      "<A-j>" = "zoom in";
      "<A-k>" = "zoom out";
      "i" = "recolor";
      "p" = "print";
    };

    options = {
      "database" = "sqlite";
      "statusbar-h-padding" = "0";
      "statusbar-v-padding" = "0";
      "page-padding" = "1";
      "selection-clipboard" = "clipboard";
    };
  };
}

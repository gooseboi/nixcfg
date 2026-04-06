{
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  xdg.configFile."pypr/config.toml".source = ./pyprland.toml;

  home.packages = [
    # Just in case, if you're naughty
    pkgs.pyprland
  ];

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "${getExe pkgs.pyprland}"
      ];
    };
  };
}

{
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    ;

  pyprland = pkgs.pyprland;

  hyprlandTarget = "hyprland-session.target";
in {
  xdg.configFile."pypr/config.toml".source = ./pyprland.toml;

  systemd.user.services.pyprland = {
    Unit = {
      Description = "Pyprland Service";
      PartOf = [hyprlandTarget];
      Requires = [hyprlandTarget];
    };

    Install.WantedBy = [hyprlandTarget];

    Service = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${getExe pyprland}";
      RestartSec = "1";
    };
  };

  home.packages = [
    pyprland
  ];
}

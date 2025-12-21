{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.chonkos.desktop;
in {
  config = mkIf cfg.enable {
    chonkos.unfree.allowed = ["discord"];
    environment.systemPackages = with pkgs; [
      anki
      discord
      ferdium
      gimp
      gparted
      libreoffice-fresh
      onlyoffice-desktopeditors
      playerctl
      ungoogled-chromium
      xfce.thunar

      zen-browser
      helium
    ];
  };
}

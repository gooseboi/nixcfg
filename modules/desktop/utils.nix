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
      helium
      libreoffice-fresh
      obs-studio
      onlyoffice-desktopeditors
      playerctl
      thunar
      ungoogled-chromium
      zen-browser
    ];
  };
}

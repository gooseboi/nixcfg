{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.typesetting;
in {
  options.chonkos.typesetting = {
    enable = mkEnableOption "enable typesetting installs";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      texliveFull
      typst
    ];
  };
}

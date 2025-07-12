{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.typesetting;
in {
  options.chonkos.typesetting = {
    enable = lib.mkEnableOption "enable typesetting installs";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      texliveFull
      typst
    ];
  };
}

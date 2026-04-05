{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkIf
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.typesetting;
in {
  options.chonkos.typesetting = {
    enable = mkBoolOption "enable typesetting installs" isDesktop;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      texliveFull
      typst
    ];
  };
}

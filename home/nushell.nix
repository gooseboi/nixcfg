{
  pkgs,
  config,
  lib,
  mkMyLib,
  ...
}: let
  myLib = mkMyLib config;
in {
  options.chonkos.nushell = {
    enable = lib.mkEnableOption "enable nushell";
  };

  config.programs.nushell = lib.mkIf config.chonkos.zsh.enable {
    enable = true;
  };
}

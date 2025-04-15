{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.nushell;
in {
  options.chonkos.nushell = {
    enable = lib.mkEnableOption "enable nushell";
  };

  config.programs.nushell = lib.mkIf cfg.enable {
    enable = true;
  };
}

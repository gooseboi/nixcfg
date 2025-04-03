{
  lib,
  config,
  ...
}: let
  cfg = config.chonkos.mosh;
in {
  options.chonkos.mosh = {
    enable = lib.mkEnableOption "enable mosh";
  };

  config = lib.mkIf cfg.enable {
    programs.mosh = {
      enable = true;
    };
  };
}

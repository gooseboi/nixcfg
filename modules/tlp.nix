{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.tlp;
in {
  options.chonkos.tlp = {
    enable = lib.mkEnableOption "enable tlp service";
    batMaxFreq = lib.mkOption {
      type = lib.types.int;
      description = "percentage to run cpu when on battery";
      example = 60;
      default = 60;
    };
  };

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = cfg.batMaxFreq;
      };
    };
  };
}

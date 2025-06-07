{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.services.fail2ban;
in {
  options.chonkos.services.fail2ban = {
    enable = mkEnableOption "enable fail2ban";
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      maxretry = 5;
      # TODO: Make this configurable
      ignoreIP = [
        "anatidae.drongo-mirach.ts.net"
        "anser.drongo-mirach.ts.net"
      ];
      bantime = "24h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
        overalljails = true;
      };
    };
  };
}

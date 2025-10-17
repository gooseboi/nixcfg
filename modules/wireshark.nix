{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.wireshark;
in {
  options.chonkos.wireshark = {
    enable = mkEnableOption "enable wireshark";
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      package = pkgs.wireshark-qt;
      enable = true;
    };

    users.groups.wireshark.members = [config.chonkos.user];
  };
}

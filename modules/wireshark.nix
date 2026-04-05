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

  cfg = config.chonkos.wireshark;
in {
  options.chonkos.wireshark = {
    enable = mkBoolOption "enable wireshark" isDesktop;
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      package = pkgs.wireshark;
      enable = true;
    };

    users.groups.wireshark.members = [config.chonkos.user];
  };
}

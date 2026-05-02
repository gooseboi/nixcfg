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
    # FIXME: Wireshark-qt stopped building
    enable = mkBoolOption "enable wireshark" false;
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      package = pkgs.wireshark;
      enable = true;
    };

    users.groups.wireshark.members = [config.chonkos.user];
  };
}

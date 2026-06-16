{lib, ...}: let
  inherit
    (lib)
    mkIf
    ;

  enable = false;
in {
  config = mkIf enable {
    networking.firewall = {
      allowedTCPPorts = [5520];
      allowedUDPPorts = [5520];
    };
  };
}

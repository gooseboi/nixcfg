{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;

  enable = true;
  dataDir = "/var/lib/teamspeak3-server";
in {
  config = mkIf enable {
    chonkos.unfree.allowed = ["teamspeak-server"];

    services.teamspeak3 = {
      enable = true;

      inherit dataDir;

      openFirewall = true;
    };
  };
}

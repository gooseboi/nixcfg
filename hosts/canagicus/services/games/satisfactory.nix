{pkgs, ...}: let
  name = "satisfactory";
in {
  chonkos.unfree.allowed = [
    "steamcmd"
    "steam-unwrapped"
  ];

  networking.firewall = {
    allowedTCPPorts = [7777 8888];
    allowedUDPPorts = [7777];
  };

  flux = {
    enable = true;
    servers = {
      satisfactory = {
        package = let
          hash = "sha256-RkF0Sm8xkTU+2Gy932vj+4rR6+1rlx+yUnJXmo5CdN4=";
        in
          pkgs.mkSteamServer {
            inherit name;
            src = pkgs.fetchSteam {
              inherit name;
              appId = "1690800";

              inherit hash;
            };

            startCmd = "FactoryServer.sh";

            # You need to pass the same hash twice, because of course
            inherit hash;
          };
      };
    };
  };
}

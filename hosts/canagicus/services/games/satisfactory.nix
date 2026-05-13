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
          hash = "sha256-GHP2/my6A85l8Wm9TK+AQD0/+03wZ2qqcmXIxqTlQtU=";
        in
          pkgs.mkSteamServer {
            inherit name;
            src = pkgs.fetchSteam {
              inherit name;
              appId = "1690800";

              inherit hash;
            };

            startCmd = "FactoryServer.sh";

            # You need to pass the same has twice, because of course
            inherit hash;
          };
      };
    };
  };
}

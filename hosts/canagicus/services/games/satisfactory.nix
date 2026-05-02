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
          hash = "sha256-NUeoBC3SVjl7+o5u5HqKCTn1Zsmj+kzhj3yOu05x/FI=";
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

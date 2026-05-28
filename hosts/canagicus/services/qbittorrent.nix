{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;

  inherit (config.networking) domain;

  enable = true;

  subDomain = "qb";
  torrentingPort = 52020;
  webuiPort = 8080;
in {
  config = mkIf enable {
    networking.firewall = {
      allowedTCPPorts = [torrentingPort];
      allowedUDPPorts = [torrentingPort];
    };

    services.qbittorrent = {
      inherit enable;

      inherit torrentingPort webuiPort;

      serverConfig = {
        LegalNotice.Accepted = true;
        General.Locale = "en";

        BitTorrent = {
          "Session\\GlobalDLSpeedLimit" = 0;
          "Session\\GlobalUPSpeedLimit" = 1024;
          "Session\\AlternativeGlobalDLSpeedLimit" = 5120;
          "Session\\AlternativeGlobalUPSpeedLimit" = 512;

          # Stop torrents upon reaching ratio=10
          "Session\\GlobalMaxRatio" = 10;
          "Session\\ShareLimitAction" = "Stop";

          # Just download and upload as many as possible at once.
          "Session\\QueueingSystemEnabled" = false;
        };

        Preferences = {
          WebUI = {
            Username = "chonk";
            Password_PBKDF2 = "MD6q8AHfFWW2YLAdGotF0A==:nxH1Q2Q6qm9JGI7nBq+zWaFx9BmAwGb1EL8QqfnbV1bcvhIEsMPdGDo7q3jLyiqucBLzLbXzVhcCH5SN/G+Uww==";
          };
        };
      };
    };

    chonkos.services.reverse-proxy.hosts.qbittorrent = {
      target = "http://127.0.0.1:${toString webuiPort}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
    };
  };
}

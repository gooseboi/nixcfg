{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe'
    mkIf
    ;

  inherit (config.networking) domain;

  enable = true;

  driveMountPath = "/media/qbittorrent";
  driveMountUnit = "media-qbittorrent.mount";

  user = "qbittorrent";
  group = "qbittorrent";

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

      inherit user group;

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

    systemd.mounts = [
      {
        type = "btrfs";
        what = "/dev/disk/by-uuid/a5e9b07f-e704-416b-ab0c-dd67310087f1";
        where = driveMountPath;
        options = "subvolid=257";
      }
    ];

    systemd.services."qbittorrent-mount-perms" = {
      requires = [driveMountUnit];
      after = [driveMountUnit];
      wantedBy = ["qbittorrent.service"];
      before = ["qbittorrent.service"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${getExe' pkgs.coreutils "chown"} ${user}:${group} ${driveMountPath}";
      };
    };

    chonkos.services.reverse-proxy.hosts.qbittorrent = {
      target = "http://127.0.0.1:${toString webuiPort}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
    };
  };
}

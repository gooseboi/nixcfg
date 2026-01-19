{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    mkIf
    ;
  inherit (config.networking) domain;

  enable = true;

  port = 4235;
  user = "rss-proxy";
  group = "rss-proxy";
  subDomain = "rss";
in {
  config = mkIf enable {
    users = {
      users.${user} = {
        inherit group;
        isSystemUser = true;
      };
      groups.${group} = {};
    };

    systemd.services.rss-proxy = {
      description = "rss-proxy: a proxy for rss requests";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        RSS_PROXY_ADDR = "127.0.0.1";
        RSS_PROXY_PORT = toString port;
        RSS_PROXY_DEVIANTART_WAITING_TIME = "12";
        RSS_PROXY_DEVIANTART_CACHE_TTL = "60";
        RSS_PROXY_DEVIANTART_MAX_ENTRIES = "300";
      };

      serviceConfig = {
        User = user;
        Group = group;

        ExecStart = getExe pkgs.rss-proxy;
        Restart = "always";

        # Hardening
        NoNewPrivileges = true;
        CapabilityBoundingSet = [""];
        RemoveIPC = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    chonkos.services.reverse-proxy.hosts.rss-proxy = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${subDomain}.${domain}";
      enableCompression = true;
    };
  };
}

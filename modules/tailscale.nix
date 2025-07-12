{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.chonkos.tailscale;
in {
  options.chonkos.tailscale = {
    enable = mkEnableOption "enables tailscale";

    enableExitNode = mkEnableOption "enables support to make this device an exit node";

    preferredInterface = mkOption {
      type = types.str;
      description = "Interface to use for tailscale (used to enable UDP gro forwarding";
      example = "eth0";
      readOnly = true;
    };

    interfaceName = mkOption {
      type = types.str;
      description = "Interface name for the tailscale interface";
      example = "ts0";
      default = "ts0";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [config.services.tailscale.package];

    services.tailscale = {
      enable = true;
      interfaceName = cfg.interfaceName;
      useRoutingFeatures = "both";
    };

    systemd.services.tailscaled.serviceConfig = {
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

    services.resolved = {
      enable = true;
      dnssec = "false";
    };

    networking = {
      useNetworkd = true;
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [cfg.interfaceName];
      };
    };

    # https://tailscale.com/kb/1019/subnets#enable-ip-forwarding
    boot.kernel.sysctl = lib.mkIf cfg.enableExitNode {
      "net.ipv4.ip_forward" = "1";
      "net.ipv6.conf.all.forwarding" = "1";
    };

    # https://tailscale.com/kb/1320/performance-best-practice#linux-optimizations-for-subnet-routers-and-exit-nodes
    systemd.services.tailscale-transport-layer-offloads = lib.mkIf cfg.enableExitNode {
      description = "better performance for tailscale exit nodes";
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${cfg.preferredInterface} rx-udp-gro-forwarding on rx-gro-list off";
      };
      wantedBy = ["default.target"];
    };
  };
}

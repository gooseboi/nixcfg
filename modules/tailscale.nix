{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos;
in {
  options.chonkos.tailscale = {
    enable = lib.mkEnableOption "enables tailscale";
    enableExitNode = lib.mkEnableOption "enables support to make this device an exit node";
    preferredInterface = lib.mkOption {
      type = lib.types.str;
      description = "Interface to use for tailscale (used to enable UDP gro forwarding";
      example = "eth0";
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.tailscale.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    services.resolved = {
      enable = true;
      dnssec = "false";
    };

    networking = {
      useNetworkd = true;
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = ["tailscale0"];
      };
    };

    # https://tailscale.com/kb/1019/subnets#enable-ip-forwarding
    boot.kernel.sysctl = lib.mkIf cfg.tailscale.enableExitNode {
      "net.ipv4.ip_forward" = "1";
      "net.ipv6.conf.all.forwarding" = "1";
    };

    # https://tailscale.com/kb/1320/performance-best-practice#linux-optimizations-for-subnet-routers-and-exit-nodes
    systemd.services.tailscale-transport-layer-offloads = lib.mkIf cfg.tailscale.enableExitNode {
      description = "better performance for tailscale exit nodes";
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${cfg.tailscale.preferredInterface} rx-udp-gro-forwarding on rx-gro-list off";
      };
      wantedBy = ["default.target"];
    };
  };
}

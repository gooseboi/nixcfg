{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    mkBoolOption
    mkDisableOption
    mkEnableOption
    mkForce
    mkIf
    mkOption
    types
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.tailscale;
in {
  options.chonkos.tailscale = {
    enable = mkDisableOption "enables tailscale";

    enableExitNode = mkEnableOption "enables support to make this device an exit node";

    interfaceName = mkOption {
      type = types.str;
      description = "Interface name for the tailscale interface";
      example = "ts0";
      default = "ts0";
    };

    tailray = mkOption {
      default = {};
      type = types.submodule {
        options = {
          enable = mkBoolOption "enable installing and enabling tailray service" isDesktop;
        };
      };
    };
  };

  config = mkIf cfg.enable {
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
      settings.Resolve.DNSSEC = "false";
    };

    networking = {
      useNetworkd = true;
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [cfg.interfaceName];
      };
    };

    # https://tailscale.com/kb/1019/subnets#enable-ip-forwarding
    boot.kernel.sysctl = mkIf cfg.enableExitNode {
      "net.ipv4.ip_forward" = "1";
      "net.ipv6.conf.all.forwarding" = "1";
    };

    # https://tailscale.com/kb/1320/performance-best-practice#linux-optimizations-for-subnet-routers-and-exit-nodes
    systemd.services.tailscale-transport-layer-offloads = mkIf cfg.enableExitNode {
      description = "better performance for tailscale exit nodes";
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          pkgs.writeShellScriptBin "tailscale-transport-layer-offloads"
          # bash
          ''
            set -eu
            netdev=$(${getExe' pkgs.iproute2 "ip"} -o route get 8.8.8.8 | ${getExe' pkgs.coreutils "cut"} -f 5 -d " ")
            echo "Turning on UDP transport layer offloads on $netdev"
            ${getExe pkgs.ethtool} -K $netdev rx-udp-gro-forwarding on rx-gro-list off
          ''
          |> getExe;
      };
      wantedBy = ["default.target"];
    };

    home-manager.sharedModules = mkIf cfg.tailray.enable [
      {
        services.tailray.enable = true;

        systemd.user.services.tailray = {
          # This is to replace the value "graphical-session-pre.target" from
          # upstream with "graphical-session.target". Why exactly this is
          # necessary is beyond me, but it fixes the problem. The reason I
          # tried setting it to be this is because network-manager-applet has
          # it done like this.
          Unit.After = mkForce ["graphical-session.target" "tray.target"];
        };
      }
    ];
  };
}

# TODO: Prometheus: https://gate.minekube.com/guide/otel/self-hosted/grafana-stack
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrsToList filter mkEnableOption mkIf mkOption types;

  gate = pkgs.buildGoModule (finalAttrs: {
    pname = "gate";
    version = "0.49.1";

    src = pkgs.fetchFromGitHub {
      owner = "minekube";
      repo = "gate";
      tag = "v${finalAttrs.version}";
      sha256 = "sha256-gDRw/YQtIpYiX3uKjvmttbVkohj2k5f+pvv+xYyY3S8=";
    };

    subPackages = ["."];

    vendorHash = "sha256-4LJwb4ZXs+CUcxhvRveJy+xu7/UEjxIEwLV5Z5gBbT4=";

    meta.mainProgram = "gate";
  });

  cfg = config.chonkos.services.mc-gate;
in {
  options.chonkos.services.mc-gate = {
    enable = mkEnableOption "enable mc-gate";
    package = mkOption {
      description = "the package to run";
      default = gate;
    };

    bindAddress = mkOption {
      description = "the address to bind to";
      default = "0.0.0.0";
      type = types.str;
    };

    bindPort = mkOption {
      description = "the address to bind to";
      default = 25565;
      type = types.port;
    };

    openFirewall = mkEnableOption "whether to open the firewall at the port specified";

    user = mkOption {
      default = "mc-gate";
      type = types.str;
      description = "user which runs gate";
    };

    group = mkOption {
      default = "mc-gate";
      type = types.str;
      description = "group which runs gate";
    };

    servers = mkOption {
      description = "the servers to forward";
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "enable this forwarding";
            src = mkOption {
              type = types.str;
              example = "mc.example.net";
              description = "source";
            };
            dest = mkOption {
              type = types.str;
              example = "hypixel.net";
              description = "destination";
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    users = {
      users = mkIf (cfg.user == "mc-gate") {
        mc-gate = {
          description = "Minecraft Gate service user";
          isSystemUser = true;
          inherit (cfg) group;
        };
      };
      groups.mc-gate = mkIf (cfg.group == "mc-gate") {};
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.bindPort];
      allowedUDPPorts = [cfg.bindPort];
    };

    systemd.services.mc-gate = let
      # toYAML = name: data: pkgs.writeText name (lib.generators.toYAML {} data);
      config_yml =
        (pkgs.callPackage lib.convertToYAML {}) "mc-gate-config.yml"
        {
          config = {
            bind = "${cfg.bindAddress}:${toString cfg.bindPort}";

            lite = {
              enabled = true;
              routes =
                cfg.servers
                |> attrsToList
                |> map ({value, ...}: value)
                |> filter (cfg: cfg.enable)
                |> map (cfg: {
                  host = cfg.src;
                  backend = cfg.dest;
                });
            };
          };
        };
    in {
      enable = true;
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = [
          "${lib.getExe cfg.package}"
        ];

        User = cfg.user;
        Group = cfg.group;

        # Hardening
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

      environment = {
        GATE_CONFIG = "${config_yml}/mc-gate-config.yml";
        GATE_DEBUG = "true";
      };
    };
  };
}

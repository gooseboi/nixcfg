{
  lib,
  pkgs,
  ...
}: let
  user = "tazos";
  group = "tazos";

  java = pkgs.temurin-jre-bin-25;

  serviceDirName = "tazos";
  serviceDir = "/var/lib/mc/${serviceDirName}";
in {
  config = {
    users = {
      users = {
        ${user} = {
          isSystemUser = true;
          inherit group;
          extraGroups = ["mc"];
        };
      };
      groups.${group} = {};
    };

    systemd.services.tazos = {
      enable = true;
      after = ["network.target" "mc-gate.service"];
      wants = ["network.target"];
      wantedBy = ["mc-gate.service"];

      serviceConfig = {
        ExecStart =
          # I cannot be bothered to package the server using nix, and since it's
          # written in Java you can just run java in the directory with the files
          # there
          pkgs.writeShellApplication {
            name = "tazos";
            runtimeInputs = [java];
            text =
              # bash
              ''
                cd ${serviceDir}

                java \
                @java_args.txt \
                -jar fabric-server.jar \
                nogui
              '';
          }
          |> lib.getExe;

        User = user;
        Group = group;

        StateDirectory = serviceDirName;
        StateDirectoryMode = "0750";

        # Hardening
        # NOTE: I'm not even gonna try hardening, because I can't be bothered to debug it.
        # LockPersonality = true;
        # NoNewPrivileges = true;
        # ProtectClock = true;
        # ProtectControlGroups = true;
        # ProtectHome = true;
        # ProtectHostname = true;
        # ProtectKernelLogs = true;
        # ProtectKernelModules = true;
        # ProtectKernelTunables = true;
        # ProtectProc = "invisible";
        # ProtectSystem = "strict";
        # RemoveIPC = true;
        # RestrictNamespaces = true;
        # RestrictRealtime = true;
        # RestrictSUIDSGID = true;
        # PrivateTmp = true;
        # SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      };
    };
  };
}

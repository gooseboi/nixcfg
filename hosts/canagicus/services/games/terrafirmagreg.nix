{
  lib,
  pkgs,
  ...
}: let
  user = "terragreg";
  group = "terragreg";

  java = pkgs.temurin-jre-bin-21;

  serviceDirName = "terragreg";
  serviceDir = "/var/lib/${serviceDirName}";
in {
  config = {
    users = {
      users = {
        ${user} = {
          isSystemUser = true;
          inherit group;
        };
      };
      groups.${group} = {};
    };

    systemd.services.terragreg = {
      enable = true;
      # The server uses some forge updating bullshit for some reason and
      # so it needs to have network-online instead of just network
      after = ["network-online.target" "mc-gate.service"];
      wantedBy = ["mc-gate.service"];

      serviceConfig = {
        ExecStart =
          # I cannot be bothered to package the server using nix, and since it's
          # written in Java you can just run java in the directory with the files
          # there
          pkgs.writeShellApplication {
            name = "terrafirmagreg-start";
            runtimeInputs = [java];
            text =
              # bash
              ''
                cd ${serviceDir}

                java \
                @java_args.txt \
                -jar minecraft_server.jar \
                nogui
              '';
          }
          |> lib.getExe;

        User = user;
        Group = group;

        StateDirectory = serviceDirName;
        StateDirectoryMode = "0750";

        # Hardening
        LockPersonality = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateTmp = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      };
    };
  };
}

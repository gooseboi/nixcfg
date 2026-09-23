{
  lib,
  pkgs,
  ...
}: let
  version = "2.8.4";

  serverZip = pkgs.fetchzip {
    url = "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_${version}_Server_Java_17-25.zip";
    hash = "sha256-WgTv53dNuH9jZ3L4+STDB/ydRjkWd1iVU7Mzpsp/Pls=";
    stripRoot = false;
  };

  serverFiles = pkgs.stdenvNoCC.mkDerivation {
    pname = "gtnh-files";
    inherit version;

    src = serverZip;

    installPhase =
      # bash
      ''
        mkdir --parent $out

        cp --dereference --recursive $src/mods $out
        cp --dereference --recursive $src/config $out
        cp --dereference --recursive $src/journeymap $out
        cp --dereference --recursive $src/serverutilities $out

        cp --dereference $src/server-icon.png $out
      '';
  };

  serverDeps = pkgs.stdenvNoCC.mkDerivation {
    pname = "gtnh-forge";
    inherit version;

    src = serverZip;

    installPhase =
      # bash
      ''
        mkdir --parent $out

        cp --dereference --recursive $src/libraries $out

        cp --dereference $src/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar $out
        cp --dereference $src/lwjgl3ify-forgePatches.jar $out
        cp --dereference $src/minecraft_server.1.7.10.jar $out
        cp --dereference $src/java9args.txt $out
      '';
  };

  user = "gtnh";
  group = "gtnh";

  java = pkgs.temurin-jre-bin-21;

  serviceDirName = "gtnh";
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

    systemd.services.gtnh = {
      enable = true;
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart =
          pkgs.writeShellScriptBin "gtnh-start"
          # bash
          ''
            if [ ! -f ${serviceDir}/.link ]; then
              cp --recursive --symbolic-link ${serverFiles}/. ${serviceDir}

              # This is mainly for the config thing below, but also just in case
              # it's ever needed
              chmod +w -R ${serviceDir}

              # The config files need to be writeable because for some reason
              # some mods need to write to the config file at startup
              rm --recursive --force ${serviceDir}/config
              cp --recursive --dereference ${serverFiles}/config ${serviceDir}/config
              chmod +w -R ${serviceDir}/config

              # This is just for convenience, to edit the config
              rm --recursive --force ${serviceDir}/serverutilities
              cp --recursive --dereference ${serverFiles}/serverutilities ${serviceDir}/serverutilities
              chmod +w -R ${serviceDir}/serverutilities

              touch ${serviceDir}/.link
            fi

            cd ${serviceDir}

            ${lib.getExe java} --class-path ${serverDeps} \
            @${serverDeps}/java9args.txt \
            -jar ${serverDeps}/lwjgl3ify-forgePatches.jar \
            nogui
          ''
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

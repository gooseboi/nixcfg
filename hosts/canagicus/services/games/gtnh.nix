{pkgs, ...}: let
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

        cp --symbolic-link --recursive $src/mods $out
        cp --symbolic-link --recursive $src/config $out
        cp --symbolic-link --recursive $src/journeymap $out
        cp --symbolic-link --recursive $src/serverutilities $out

        cp --symbolic-link $src/server-icon.png $out
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

        cp --symbolic-link --recursive $src/libraries $out

        cp --symbolic-link $src/forge-1.7.10-10.13.4.1614-1.7.10-universal.jar $out
        cp --symbolic-link $src/lwjgl3ify-forgePatches.jar $out
        cp --symbolic-link $src/minecraft_server.1.7.10.jar $out
        cp --symbolic-link $src/java9args.txt $out
      '';
  };
in {
  # TODO: Finish this

  # java --class-path ${serverDeps} @${serverDeps}/java9args.txt -jar ${serverDeps}/lwjgl3ify-forgePatches.jar nogui
  config = {
    systemd.services.gtnh = {
      serviceConfig = {
        ExecStart =
          pkgs.writeShellScriptBin "gtnh-start"
          # bash
          ''
            ls ${serverFiles}
            ls ${serverDeps}
          '';
      };
    };
  };
}

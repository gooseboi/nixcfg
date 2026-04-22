{
  lib,
  appimageTools,
  fetchurl,
  ...
}: let
  inherit (lib.lists) optional;

  baseUrl = "https://github.com/pingdotgg/t3code";

  version = "0.0.20";
  pname = "t3code";

  src = fetchurl {
    url = "${baseUrl}/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-glYnF8UA5s4rrpUJuvk4HlQtyMikbckIkmMIhnJugO4=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop \
                        $out/share/applications/${pname}.desktop

      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/${pname}.png \
                          $out/share/icons/hicolor/1024x1024/apps/${pname}.png

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';

    meta = {
      description = "T3 Code is a minimal web GUI for coding agents";
      homepage = "${baseUrl}";
      downloadPage = "${baseUrl}/releases";
      license = lib.licenses.mit;
      mainProgram = "t3code";
      platforms = ["x86_64-linux"];
    };
  }

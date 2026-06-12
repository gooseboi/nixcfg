{
  lib,
  appimageTools,
  fetchurl,
  ...
}: let
  inherit (lib.lists) optional;

  baseUrl = "https://github.com/pingdotgg/t3code";

  version = "0.0.27";
  pname = "t3code";

  src = fetchurl {
    url = "${baseUrl}/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-ALkm7wSVbDlZR7TWVag3NRbP1kvGJQqmpR1mmZvSCAU=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop \
                        $out/share/applications/${pname}.desktop

      for size in 16 22 24 32 48 64 128 256 512; do
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png \
                            $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
      done

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

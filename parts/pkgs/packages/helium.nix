{
  lib,
  appimageTools,
  fetchurl,
  ...
}: let
  version = "0.7.7.1";
  pname = "helium";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-qEHUFzCwsCyFNLFCC62wo2x1lr/boAI/UDsaaNP1vrc=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/helium.desktop \
                        $out/share/applications/helium.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/helium.png \
                          $out/share/icons/hicolor/256x256/apps/helium.png

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';

    meta = {
      description = "The Chromium-based web browser made for people, with love.";
      homepage = "https://github.com/imputnet/helium";
      downloadPage = "https://github.com/imputnet/helium-linux/releases";
      license = lib.licenses.gpl3;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      mainProgram = "helium";
      platforms = ["x86_64-linux"];
    };
  }

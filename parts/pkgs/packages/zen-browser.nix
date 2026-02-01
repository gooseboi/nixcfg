{
  lib,
  appimageTools,
  fetchurl,
  ...
}: let
  version = "1.18.3b";
  pname = "zen";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage";
    hash = "sha256-NtmN2hbq0S7IdDfSET6m71d219OlzqyGXz4X4NLcuJc=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/zen.desktop \
                        $out/share/applications/zen.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/zen.png \
                          $out/share/icons/hicolor/128x128/apps/zen.png
      install -m 444 -D ${appimageContents}/browser/chrome/icons/default/default64.png \
                          $out/share/icons/hicolor/64x64/apps/zen.png
      install -m 444 -D ${appimageContents}/browser/chrome/icons/default/default48.png \
                          $out/share/icons/hicolor/48x48/apps/zen.png
      install -m 444 -D ${appimageContents}/browser/chrome/icons/default/default32.png \
                          $out/share/icons/hicolor/32x32/apps/zen.png
      install -m 444 -D ${appimageContents}/browser/chrome/icons/default/default16.png \
                          $out/share/icons/hicolor/16x16/apps/zen.png
    '';

    meta = {
      description = "Zen is a firefox-based browser with the aim of pushing your productivity to a new level!";
      homepage = "https://zen-browser.app/";
      downloadPage = "https://github.com/zen-browser/desktop/releases";
      license = lib.licenses.mpl20;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      mainProgram = "helium";
      platforms = ["x86_64-linux"];
    };
  }

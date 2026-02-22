# https://gitlab.com/Andrew/configuration/-/blob/5efb0157e7ab8283293d1d7764414ab0b8f05225/packages/nbt-explorer.nix
{
  fetchzip,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  # Dependencies
  gtk2-x11,
  mono,
}:
stdenv.mkDerivation rec {
  pname = "nbt-explorer";
  version = "2.8.0";

  src = fetchzip {
    url = "https://github.com/jaquadro/NBTExplorer/releases/download/v${version}-win/NBTExplorer-${version}.zip";
    hash = "sha256-T0FLxuzgVHBz78rScPC81Ns2X1Mw/omzvYJVRQM24iU=";
    stripRoot = false;
  };

  iconSrc = fetchFromGitHub {
    owner = "jaquadro";
    repo = "NBTExplorer";
    rev = "d29f249d7e489eaa4ccf8ba5b661cfa6ae0466ff";
    sparseCheckout = ["NBTExplorer/Resources/Dead_Bush_256.png"];
    hash = "sha256-Hq3VYZ4IztUghN2AqYB7KZIALfoinMDyEn2MjQ9eilE=";
  };

  desktopItem = makeDesktopItem {
    categories = ["Utility"];
    genericName = "Minecraft data editor";
    desktopName = "NBTExplorer";
    name = pname;
    icon = pname;
    exec = meta.mainProgram;
  };

  phases = ["installPhase" "patchPhase"];
  nativeBuildInputs = [makeWrapper];
  installPhase = ''
    mkdir -p $out/lib
    cp --target-directory $out/lib \
      $src/NBTExplorer.exe \
      $src/NBTModel.dll \
      $src/Substrate.dll

    makeWrapper "${lib.getExe mono}" $out/bin/${pname} \
      --add-flags "$out/lib/NBTExplorer.exe" \
      --suffix LD_LIBRARY_PATH : ${gtk2-x11}/lib

    install -D $iconSrc/NBTExplorer/Resources/Dead_Bush_256.png $out/share/icons/${pname}.png
    install -D -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  meta = {
    description = "A graphical NBT editor for all Minecraft NBT data sources";
    homepage = "https://github.com/jaquadro/NBTExplorer";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}

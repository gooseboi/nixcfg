{
  lib,
  fetchzip,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "furifont";
  version = "0.6.2";

  src = fetchzip {
    url = "https://github.com/antfu/furifont/releases/download/v${version}/Furifont.zip";
    hash = "sha256-Mqh/6ujWDtCZAeO+eQq319L/3itGSjsVqfzUxzvBi64=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];
  dontInstallWebfonts = true;

  meta = {
    homepage = "https://github.com/antfu/furifont";
    description = "A japanese font that shows furigana by itself";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}


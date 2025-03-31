{
  lib,
  stdenv,
  fetchurl,
  cups,
  dpkg,
  gnused,
  makeWrapper,
  ghostscript,
  file,
  a2ps,
  coreutils,
  gnugrep,
  which,
  gawk,
}: let
  version = "3.5.0";
  model = "dcpt420w";
in
  stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf105168/${model}pdrv-${version}-1.i386.deb";
      sha256 = "6daf0144b5802ea8da394ca14db0e6f0200d4049545649283791f899b7f7bd26";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];
    buildInputs = [
      cups
      ghostscript
      a2ps
      gawk
    ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      # substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter_${model} \
      # --replace /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brlpdwrapper${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${
        lib.makeBinPath [
          gawk
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]
      }
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer driver";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_all&os=128";
    };
  }

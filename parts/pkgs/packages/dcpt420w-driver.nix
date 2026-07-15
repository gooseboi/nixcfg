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
  perl,
  a2ps,
  coreutils,
  gnugrep,
  which,
  gawk,
  libredirect,
}: let
  version = "3.5.0";
  model = "dcpt420w";

  binPath = lib.makeBinPath [
    gawk
    ghostscript
    a2ps
    file
    gnused
    gnugrep
    coreutils
    which
  ];
in
  stdenv.mkDerivation {
    pname = "cups-brother-${model}";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf105168/${model}pdrv-${version}-1.i386.deb";
      sha256 = "sha256-Pt6BmmWuw3nsdnb3rAysq9cIefuq8seXjurkBsDhwfI=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    buildInputs = [
      cups
      ghostscript
      a2ps
      perl
      gawk
    ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      LPDDIR=$out/opt/brother/Printers/${model}/lpd
      WRAPPERDIR=$out/opt/brother/Printers/${model}/cupswrapper

      ln -s $LPDDIR/${stdenv.hostPlatform.linuxArch}/* $LPDDIR/

      # NOTE: The interpreter directive of this file (/usr/bin/perl) is patched
      # by the fixup phase automagically, so we don't need to worry.
      #
      # The wrapper renames the file from filter_<model> to
      # .filter_<model>-wrapped, but the regex doesn't handle this
      substituteInPlace $LPDDIR/filter_${model} \
        --replace-fail "/usr/bin/pdf2ps" "${ghostscript}/bin/pdf2ps" \
        --replace-fail '$PRINTER =~ s/\.pl$//;' '$PRINTER =~ s/\.pl$//; $PRINTER =~ s/-wrapped$//;'

      # NOTE: The lpdwrapper Perl script extracts the model name from its own
      # path using a regex that assumes /opt/ prefix. On NixOS the path starts
      # with /nix/store/, so the regex must be relaxed to match any prefix.
      #
      # The lpdwrapper extracts $basedir using `readlink $0`, which returns a
      # relative symlink target. Use `realpath` instead so $basedir (and thus
      # $LPDFILTER) are absolute paths that resolve correctly from any CWD.
      #
      # the lpdconf thing is just plain wrong before... It copies the wrong file
      # and therefore the print settings are not respected in the print
      substituteInPlace $WRAPPERDIR/brother_lpdwrapper_${model} \
        --replace-fail 'my $basedir = `readlink $0`;' 'my $basedir = `realpath $0`;' \
        --replace-fail 's/^\/opt\/.*\/Printers\///g' 's/^.*\/opt\/.*\/Printers\///g' \
        --replace-fail 'my $lpdconf_command = "$lpdconf $op $val -rcfile $TEMPRC";' 'my $lpdconf_command = "$lpddir$lpdconf $op $val -rcfile $TEMPRC";'

      wrapProgram $LPDDIR/filter_${model} \
        --prefix PATH ":" ${binPath}

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/br${model}filter
      wrapProgram $LPDDIR/br${model}filter \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /opt=$out/opt

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconf_${model}
      wrapProgram $LPDDIR/brprintconf_${model} \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /opt=$out/opt

      mkdir -p $out/lib/cups/filter/
      ln -s $LPDDIR/filter_${model} $out/lib/cups/filter/brlpdwrapper${model}
      ln -s $WRAPPERDIR/brother_lpdwrapper_${model} $out/lib/cups/filter/

      mkdir -p $out/share/cups/model
      ln -s $WRAPPERDIR/brother_${model}_printer_en.ppd $out/share/cups/model

      wrapProgram $WRAPPERDIR/brother_lpdwrapper_${model} \
        --prefix PATH ":" ${binPath}

      wrapProgram $WRAPPERDIR/cupswrapper${model} \
        --prefix PATH ":" ${binPath}
    '';

    meta = {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer driver";
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux" "i686-linux"];
      downloadPage = "https://support.brother.com/g/b/downloadtop.aspx?c=us_ot&lang=en&prod=${model}_all";
    };
  }

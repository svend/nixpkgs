{ stdenv, fetchurl, cups, dpkg, ghostscript, patchelf, bash, file }:

stdenv.mkDerivation rec {
  name = "hll2340dw-cupswrapper-${version}";
  version = "3.2.0-1";

  srcs =
    [ (fetchurl {
        url = "http://download.brother.com/welcome/dlf101912/hll2340dlpr-${version}.i386.deb";
        sha256 = "c0ae98b49b462cd8fbef445550f2177ce9d8bf627c904e182daa8cbaf8781e50";
      })
      (fetchurl {
        url = "http://download.brother.com/welcome/dlf101913/hll2340dcupswrapper-${version}.i386.deb";
        sha256 = "8aa24a6a825e3a4d5b51778cb46fe63032ec5a731ace22f9ef2b0ffcc2033cc9";
      })
    ];

  buildInputs = [ dpkg cups patchelf bash ];

  unpackPhase = "true";

  installPhase = ''
    for s in $srcs; do dpkg-deb -x $s $out; done

    substituteInPlace $out/opt/brother/Printers/HLL2340D/cupswrapper/brother_lpdwrapper_HLL2340D \
      --replace /opt "$out/opt" \
      --replace /usr "$out/usr"

    substituteInPlace $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D \
      --replace file "/run/current-system/sw/bin/file"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D

    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/opt/brother/Printers/HLL2340D/inf/braddprinter
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/opt/brother/Printers/HLL2340D/lpd/brprintconflsr3
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/opt/brother/Printers/HLL2340D/lpd/rawtobr3

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/HLL2340D/cupswrapper/brother_lpdwrapper_HLL2340D $out/lib/cups/filter/brother_lpdwrapper_HLL2340D
  '';

  meta = {
    homepage = http://www.brother.com/;
    description = "A driver for brother hll2340dw printers to print over WiFi and USB";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    downloadPage = http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=hll2340dw_us_eu_as&os=128;
  };
}

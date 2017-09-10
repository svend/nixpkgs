{ stdenv, fetchFromGitHub, pkgconfig, libX11, libXtst, xextproto,
libXi }:

let
  baseName = "xcape";
  version = "1.2-dev";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "alols";
    repo = baseName;
    rev = "6ded5b453b50642197044a170402664cbf6d2c96";
    sha256 = "193dz9n3y5jchxnpzm2yyyhx30ncn2s8rfr3hhr18aldi0cv548k";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libX11 libXtst xextproto libXi ];

  makeFlags = [ "PREFIX=$(out)" "MANDIR=/share/man/man1" ];

  postInstall = "install -D --target-directory $out/share/doc README.md";

  meta = {
    description = "Utility to configure modifier keys to act as other keys";
    longDescription = ''
      xcape allows you to use a modifier key as another key when
      pressed and released on its own.  Note that it is slightly
      slower than pressing the original key, because the pressed event
      does not occur until the key is released.  The default behaviour
      is to generate the Escape key when Left Control is pressed and
      released on its own.
    '';
    homepage = https://github.com/alols/xcape;
    license = stdenv.lib.licenses.gpl3 ;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}

{ stdenv, fetchgit, autoconf, automake, ncurses, xlibsWrapper, libXaw, libXpm, Xaw3d
, pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf, libxml2, imagemagick, gnutls
, alsaLib, cairo, acl, gpm, AppKit
, withX ? !stdenv.isDarwin
, withGTK3 ? false, gtk3 ? null
, withGTK2 ? true, gtk2
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert stdenv.isDarwin -> libXaw != null;       # fails to link otherwise
assert withGTK2 -> withX || stdenv.isDarwin;
assert withGTK3 -> withX || stdenv.isDarwin;
assert withGTK2 -> !withGTK3 && gtk2 != null;
assert withGTK3 -> !withGTK2 && gtk3 != null;

let
  toolkit =
    if withGTK3 then "gtk3"
    else if withGTK2 then "gtk2"
    else "lucid";
in

stdenv.mkDerivation rec {
  # nix-prefetch-git --rev refs/heads/emacs-25 git://git.sv.gnu.org/emacs.git
  srcRev = "f99b51295b86770e4b16d4717c0e73049191c4c5";
  srcSha = "1qim9fal00zz940dfhcifrphdw00rsbm3k6rx49s0icn6xzcgv3v";
  srcDate = "2016-03-29";

  name = "emacs-25.0-git-${srcDate}-${builtins.substring 0 7 srcRev}";
  builder = ./builder.sh;

  src = fetchgit {
    url = "git://git.sv.gnu.org/emacs.git";
    rev = srcRev;
    sha256 = srcSha;
    };

    patches = stdenv.lib.optionals stdenv.isDarwin [
    ./at-fdcwd.patch
    ];

    postPatch = ''
    sed -i 's|/usr/share/locale|${gettext}/share/locale|g' lisp/international/mule-cmds.el
    '';

    buildInputs =
    [ automake autoconf ncurses gconf libxml2 gnutls alsaLib pkgconfig texinfo acl gpm gettext ]
    ++ stdenv.lib.optional stdenv.isLinux dbus
    ++ stdenv.lib.optionals stdenv.isDarwin
       [ libpng libjpeg libungif libtiff librsvg imagemagick ]
       ++ stdenv.lib.optionals withX
       [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
         imagemagick gconf ]
         ++ stdenv.lib.optional (withX && withGTK2) gtk2
         ++ stdenv.lib.optional (withX && withGTK3) gtk3
         ++ stdenv.lib.optional (stdenv.isDarwin && withX) cairo;

         propagatedBuildInputs = stdenv.lib.optional stdenv.isDarwin AppKit;

         # preConfigure = "./autogen.sh";
         preConfigurePhases = [ "./autogen.sh" ];

         configureFlags =
         if stdenv.isDarwin
         then [ "--with-ns" "--disable-ns-self-contained" ]
         else if withX
         then [ "--with-x-toolkit=${toolkit}" "--with-xft" ]
         else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
              "--with-gif=no" "--with-tiff=no" ];

              NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (stdenv.isDarwin && withX)
              "-I${cairo}/include/cairo";

              postInstall = ''
              mkdir -p $out/share/emacs/site-lisp/
              cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
              '' + stdenv.lib.optionalString stdenv.isDarwin ''
              mkdir -p $out/Applications
              mv nextstep/Emacs.app $out/Applications
              '';

              doCheck = false;

              meta = with stdenv.lib; {
              description = "GNU Emacs 24, the extensible, customizable text editor";
              homepage    = http://www.gnu.org/software/emacs/;
              license     = licenses.gpl3Plus;
              maintainers = with maintainers; [ chaoflow lovek323 simons the-kenny ];
              platforms   = platforms.all;

              # So that Exuberant ctags is preferred
              priority = 1;

              longDescription = ''
              GNU Emacs is an extensible, customizable text editor—and more.  At its
              core is an interpreter for Emacs Lisp, a dialect of the Lisp
              programming language with extensions to support text editing.

              The features of GNU Emacs include: content-sensitive editing modes,
              including syntax coloring, for a wide variety of file types including
              plain text, source code, and HTML; complete built-in documentation,
              including a tutorial for new users; full Unicode support for nearly all
              human languages and their scripts; highly customizable, using Emacs
              Lisp code or a graphical interface; a large number of extensions that
              add other functionality, including a project planner, mail and news
              reader, debugger interface, calendar, and more.  Many of these
              extensions are distributed with GNU Emacs; others are available
              separately.
              '';
              };
              }

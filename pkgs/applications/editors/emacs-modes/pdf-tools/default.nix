{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "pdf-tools";

  src = fetchgit {
    url = "https://github.com/politza/pdf-tools.git";
    rev = "0fe0a54037079b2c6eda1974bc7148b0b8da5643";
    sha256  = "83dc116df3f190460d652b97bbfc5a18e5b7dbd80db77f33e73b6c62e7462933";
  };

  meta = {
    homepage = https://github.com/politza/pdf-tools;
    description = "FILL ME IN";
    platforms = stdenv.lib.platforms.all;
  };
}

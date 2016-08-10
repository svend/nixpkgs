{ stdenv, fetchurl, makeWrapper, jre, utillinux, getopt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.3.4";
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${version}/${name}.tar.gz";
    sha256 = "0vphyqhna510y8bcihlmz3awzszgyfpmzrfcy548a2pd9mghq7ip";
  };

  patches = [ ./es-home-2.x.patch ];

  buildInputs = [ makeWrapper jre ] ++
    (if (!stdenv.isDarwin) then [utillinux] else [getopt]);

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules $out

    # don't want to have binary with name plugin
    mv $out/bin/plugin $out/bin/elasticsearch-plugin
       wrapProgram $out/bin/elasticsearch ${if (!stdenv.isDarwin)
        then ''--prefix PATH : "${utillinux}/bin/"''
        else ''--prefix PATH : "${getopt}/bin"''} \
      --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [
      maintainers.offline
      maintainers.markWot
    ];
  };
}

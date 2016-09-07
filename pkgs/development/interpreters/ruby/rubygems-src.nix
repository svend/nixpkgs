# https://github.com/rubygems/rubygems/pull/1683
{ fetchurl
, version ? "2.6.4"
, sha256 ? "1s30l86jkingiv3c2pmfn4jg05439wvkkjg8ah8b64if8r11zmwl"
}:
fetchurl {
  url = "http://production.cf.rubygems.org/rubygems/rubygems-${version}.tgz";
  sha256 = sha256;
}

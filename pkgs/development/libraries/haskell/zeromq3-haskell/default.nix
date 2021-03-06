# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, async, checkers, MonadCatchIOTransformers
, QuickCheck, semigroups, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq3-haskell";
  version = "0.5.2";
  sha256 = "1ky92qwyk27qsxnvaj0mc9yyhk7g19ry2nq55666ayahc899z213";
  buildDepends = [
    async MonadCatchIOTransformers semigroups transformers
  ];
  testDepends = [
    ansiTerminal async checkers MonadCatchIOTransformers QuickCheck
    transformers
  ];
  pkgconfigDepends = [ zeromq ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 3.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})

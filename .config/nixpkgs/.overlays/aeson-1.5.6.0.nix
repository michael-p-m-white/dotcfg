final: prev:
let
  haskellLib = prev.haskell.lib;
in
with haskellLib;
{
  haskellPackages = final.lib.dontRecurseIntoAttrs (prev.haskellPackages.extend (haskellFinal: haskellPrev:
    {
      aeson_1_5_6_0 = appendPatch haskellPrev.aeson_1_5_6_0 ./patches/aeson-1.5.6.0.patch;
    }
  ));
}

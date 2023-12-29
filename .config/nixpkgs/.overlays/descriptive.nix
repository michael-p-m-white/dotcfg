final: prev:
let
  haskellLib = final.haskell.lib;
in
with haskellLib;
{
  haskellPackages = final.lib.dontRecurseIntoAttrs (prev.haskellPackages.extend (haskellFinal: haskellPrev:
    {
      descriptive = appendPatch haskellPrev.descriptive ./patches/descriptive.patch;
    }
  ));
}

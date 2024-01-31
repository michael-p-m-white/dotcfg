final: prev:
let
  inherit (final.lib)
    recurseIntoAttrs
  ;
in
{
  elmPackages = recurseIntoAttrs (final.callPackage ./elm { });
}

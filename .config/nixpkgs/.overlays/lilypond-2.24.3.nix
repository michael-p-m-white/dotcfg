final: prev:
{
  lilypond =
    let
      lilypond = prev.lilypond;
      fetchurl = final.fetchurl;
      lib      = final.lib;
    in
      # When I updated to nixpkgs revision d02d818f, I found that Lilypond no longer worked.
      # It appears to be because, with this revision, Lilypond now uses Ghostscript 10.02.1,
      # which no longer provides the "finddevice" command which Lilypond uses.
      #
      # This was fixed in Lilypond commit 7ab250c7, which has been integrated into lilypond version 2.24.3
      # See https://gitlab.com/lilypond/lilypond/-/issues/6675 for details.
      if prev.lilypond.version == "2.24.2" then
        lilypond.overrideAttrs (finalAttrs: prevAttrs: rec {
          version = "2.24.3";
          src = fetchurl {
            url = "http://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
            sha256 = "sha256-3wBfdu969aTNdKEPjnEVJ4t/p58UAYk3tlwQlJjsRL4=";
          };
        })
      else
        lilypond
  ;
}

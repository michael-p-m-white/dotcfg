final: prev: {
  j = prev.j.overrideAttrs (finalAttrs: prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [
      ./patches/j-cflags.patch
    ];
  });
}

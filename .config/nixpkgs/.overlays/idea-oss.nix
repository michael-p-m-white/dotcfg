final: prev: {
  jetbrains = prev.jetbrains // final.lib.recurseIntoAttrs (
    final.callPackages ./jetbrains-idea-oss {
      vmopts = final.config.jetbrains.vmopts or null;
    }
  );
}

final: prev: {
  jujutsu = final.callPackage ./jujutsu {
    inherit (final.darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };
}



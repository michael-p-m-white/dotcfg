final: prev: {
  alacritty = final.callPackage ./alacritty {
    inherit (final.darwin.apple_sdk_11_0.frameworks) AppKit CoreGraphics CoreServices CoreText Foundation OpenGL;
  };
  alacritty-theme = prev.alacritty-theme.overrideAttrs (oldAttrs: {
    version = "unstable-2024-01-21";
    src = final.fetchFromGitHub {
      owner = "alacritty";
      repo = "alacritty-theme";
      rev = "f03686afad05274f5fbd2507f85f95b1a6542df4";
      hash = "sha256-457kKE3I4zGf1EKkEoyZu0Fa/1O3yiryzHVEw2rNZt8=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/alacritty-theme
      install -Dt $out/share/alacritty-theme *.toml
      runHook postInstall
    '';
  });
}

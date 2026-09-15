let overlays = [
let
  idea-oss = import ./.overlays/idea-oss.nix;
  overlays = [
      (import ./.overlays/descriptive.nix)
      (import ./.overlays/j.nix)
      (import ./.overlays/alacritty.nix)
      (import ./.overlays/jujutsu.nix)
    ];

in
[
  idea-oss
]

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/2039c98a8afec8ff3273a3ac34b9e3864174ed94";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [ ./laptop/configuration.nix
          ];
      };
    };
  };
}

{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-24.11";
    };
  };

  outputs = { self, nixpkgs }@inputs: {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [ ./laptop/configuration.nix
          ];
      };

      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [ ./desktop/configuration.nix
          ];
      };

      ryzen-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [ ./ryzen-desktop/configuration.nix
          ];
      };
    };
  };
}

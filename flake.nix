{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:aylur/ags";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x84-64-linux";

      pkgs = import nixpkgs { inherit system; };
    in{
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}

{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    serverpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    serverdisko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "serverpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox.url = "github:adriankarlen/textfox";

    impermanence.url = "github:nix-community/impermanence";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    v8p = {
      url = "github:vaporii/v8p.me-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, serverpkgs, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";
    in{
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit system; };

          modules = [
            inputs.disko.nixosModules.default

            ./hosts/laptop/configuration.nix
            inputs.home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
          ];
        };
        servii = serverpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit system; };

          modules = [
            inputs.serverdisko.nixosModules.default

            ./hosts/servii/configuration.nix
            inputs.server-home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
          ];
        };
      };
    };
}

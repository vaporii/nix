{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    serverpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "serverpkgs";

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

    server-home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.05";
      inputs.nixpkgs.follows = "serverpkgs";
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

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    v8p = {
      url = "github:vaporii/v8p.me-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    "v8p.me" = {
      url = "github:vaporii/v8p.me";
      inputs.nixpkgs.follows = "serverpkgs";
    };

    "vaporii.net" = {
      url = "github:vaporii/v8p.me";
      inputs.nixpkgs.follows = "serverpkgs";
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
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit system; };

          modules = [
            inputs.disko.nixosModules.default

            ./hosts/desktop/configuration.nix
            inputs.home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
          ];
        };
        brunswick = serverpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit system; };

          modules = [
            inputs.serverdisko.nixosModules.default

            ./hosts/brunswick/configuration.nix
            inputs.server-home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
            inputs.sops-nix.nixosModules.sops
            inputs.vscode-server.nixosModules.default
          ];
        };
      };
    };
}

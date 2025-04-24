{ pkgs, lib, config, ... }:

{
  options = {
    vscode = {
      enable = lib.mkEnableOption "enable vscode module";
      nixHost = lib.mkOption {
        type = with lib.types; uniq str;
        example = "laptop";
        description = "the nixos configuration host to use for nixd";
      };
    };
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode.enable = true;
    programs.vscode.package = pkgs.vscodium;
    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        jdinhlife.gruvbox
        svelte.svelte-vscode
        # vscodevim.vim
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "workbench.colorTheme" = "Gruvbox Dark Medium";
        "nix.serverSettings" = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }";
            };
            options = rec {
              # nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.laptop.options";
              # home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
              # nixvim.expr = "${nixos.expr}.nixvim";
              nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.${config.vscode.nixHost}.options";
              home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
            };
          };
        };
      };
    };
  };
}

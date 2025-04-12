{ pkgs, ... }:

{
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      jdinhlife.gruvbox
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
            nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.laptop.options";
            home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
          };
        };
      };
    };
  };
}

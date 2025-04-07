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
    };
  };
}

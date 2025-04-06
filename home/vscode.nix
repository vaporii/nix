{ pkgs, ... }:

{
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      # vscodevim.vim
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    };
  };
}

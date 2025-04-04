{ pkgs, ... }:

{
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
    };
  };
}

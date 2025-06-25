{ lib, config, pkgs, ... }:

{
  options = {
    eww = {
      enable = lib.mkEnableOption "enable eww module";
    };
  };

  config = lib.mkIf config.eww.enable {
    programs.eww.enable = true;
    programs.eww.package = pkgs.symlinkJoin {
      name = "eww";
      paths = [ pkgs.eww ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/eww \
          --prefix PATH : ${lib.makeBinPath [ pkgs.jq pkgs.socat pkgs.hyprland-workspaces pkgs.hyprland-activewindow ] }
      '';
    };
    # programs.eww.configDir = ./eww;
  };
}

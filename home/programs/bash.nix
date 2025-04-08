{ pkgs, ... }:

{
  programs.bash = {
    shellAliases = {
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
    };

    historyControl = [ "erasedups" ];
  };
}
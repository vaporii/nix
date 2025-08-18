{ lib, config, ... }:

{
  options = {
    zsh = {
      enable = lib.mkEnableOption "enable zsh module";
    };
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      
      shellAliases = {
        clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      };

      # historyControl = [ "erasedups" ];
    };
  };
}

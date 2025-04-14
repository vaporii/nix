{ lib, config, ... }:

{
  options = {
    bash = {
      enable = lib.mkEnableOption "enable bash module";
    };
  };

  config = lib.mkIf config.bash.enable {
    programs.bash = {
      enable = true;
      
      shellAliases = {
        clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      };

      historyControl = [ "erasedups" ];
    };
  };
}
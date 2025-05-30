{ lib, config, ... }:

{
  options = {
    eww = {
      enable = lib.mkEnableOption "enable eww module";
    };
  };

  config = lib.mkIf config.eww.enable {
    programs.eww.enable = true;
    programs.eww.configDir = ./eww;
  };
}

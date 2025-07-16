{ lib, config, ... }:

{
  options = {
    vesktop = {
      enable = lib.mkEnableOption "enable vesktop module";
    };
  };

  config = lib.mkIf config.vesktop.enable {
    programs.vesktop = {
      enable = true;
    };
  };
}

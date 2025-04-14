{ pkgs, lib, config, ... }:

{
  options = {
    rofi = {
      enable = lib.mkEnableOption "enable rofi module";
    };
  };

  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland-unwrapped;
      theme = ./rofi/theme.rasi;
    };
  };
}
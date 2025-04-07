{ pkgs, ... }:

{
  programs.rofi = {
    package = pkgs.rofi-wayland-unwrapped;
    theme = ./rofi/theme.rasi;
  };
}
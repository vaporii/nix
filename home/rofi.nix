{ pkgs, ... }:

{
  programs.rofi = {
    package = pkgs.rofi-wayland-unwrapped;
    theme = "DarkBlue by Qball";
  };
}
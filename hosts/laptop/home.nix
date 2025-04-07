{ inputs, ... }:

{
  imports = [
    ../../home
    inputs.textfox.homeManagerModules.default
  ];

  programs = {
    git.enable = true;
    kitty.enable = true;
    waybar.enable = true;
    ags.enable = true;
    vscode.enable = true;
    firefox.enable = true;
    rofi.enable = true;
    fastfetch.enable = true;
  };

  services = {
    hyprpaper.enable = true;
    flameshot.enable = true;

  };

  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;
  };

  home.stateVersion = "24.11";
}

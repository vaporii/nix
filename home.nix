{ ... }:

{
  imports = [
    ./home
  ];

  programs = {
    git.enable = true;
    kitty.enable = true;
    waybar.enable = true;
    ags.enable = true;
    vscode.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;
  };

  home.stateVersion = "24.11";
}

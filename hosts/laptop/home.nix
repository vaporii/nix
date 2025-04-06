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
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [
        "${builtins.toString ../../assets/backgrounds/bocchi_the_rock.jpg}"
      ];
      wallpaper = [
        "eDP-1,${builtins.toString ../../assets/backgrounds/bocchi_the_rock.jpg}"
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;
  };

  home.stateVersion = "24.11";
}

{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../../home
  ];

  home.persistence."/persist/home" = {
    directories = [
      "Persist"
      ".ssh"
      ".mozilla"
      ".config/equibop"
      ".config/VSCodium"
    ];
    files = [
      ".bash_history"
    ];
    allowOther = true;
  };

  programs = {
    git.enable = true;
    kitty.enable = true;
    waybar.enable = true;
    ags.enable = true;
    vscode.enable = true;
    firefox.enable = true;
    rofi.enable = true;
    fastfetch.enable = true;
    bash.enable = true;
    starship.enable = true;
    virt-manager.enable = true;
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

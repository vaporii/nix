{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nixvim.homeManagerModules.nixvim
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
    # vscode.enable = true;
    firefox.enable = true;
    rofi.enable = true;
    fastfetch.enable = true;
    bash.enable = true;
    starship.enable = true;
    nixvim.enable = true;
  };

  vim.enable = true;
  vim.nixHost = "vm";

  vscode.enable = true;
  vscode.nixHost = "vm";

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

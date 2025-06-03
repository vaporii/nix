{ inputs, ... }:

{
  imports = [
    inputs.v8p.homeManagerModules.v8p
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

  programs.v8p.enable = true;

  theme.enable = true;

  bash.enable = true;
  fastfetch.enable = true;
  firefox.enable = true;
  git.enable = true;
  kitty.enable = true;
  rofi.enable = true;
  starship.enable = true;
  waybar.enable = true;
  eww.enable = true;

  vim.enable = true;
  vim.nixHost = "laptop";

  vscode.enable = true;
  vscode.nixHost = "laptop";

  hyprpaper.enable = true;
  flameshot.enable = true;

  hyprland.enable = true;
  rsync.enable = true;

  home.stateVersion = "24.11";
}

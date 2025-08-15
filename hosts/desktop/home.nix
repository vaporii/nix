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
      ".config/VSCodium"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      ".config/equibop"
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
  vesktop.enable = false;

  waybar = {
    enable = true;
    modulesRight = [
      "custom/start"
      "pulseaudio" "custom/end" "custom/start"
      "memory" "custom/end" "custom/start"
      "cpu" "custom/end" "custom/start"
      "temperature" "custom/end" "custom/start"
      "network" "custom/end" "custom/start"
      "clock"
    ];
    monitors = [ "DP-1" ];
  };

  eww.enable = true;

  vim.enable = true;
  vim.nixHost = "desktop";

  vscode.enable = true;
  vscode.nixHost = "desktop";

  hyprpaper = {
    enable = true;
    monitors = [
      {
        monitorName = "DP-1";
        path = ../../assets/backgrounds/bocchi_the_rock_city.jpg;
      }
      {
        monitorName = "HDMI-A-1";
        path = ../../assets/backgrounds/bocchi_the_rock_city.jpg;
      }
    ];
  };
  flameshot.enable = true;

  hyprland = {
    enable = true;
    monitors = [
      "HDMI-A-1,1920x1080@60,0x0,1,bitdepth,8,cm,auto"
      "DP-1,2560x1440@180,1920x-360,1,bitdepth,8,cm,auto"
    ];
  };
  rsync.enable = true;

  home.stateVersion = "24.11";
}

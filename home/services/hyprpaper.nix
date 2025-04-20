{ lib, config, ... }:

{
  options.hyprpaper.enable = lib.mkEnableOption "hyprpaper";

  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper.settings = {
      preload = [
        "${../../assets/backgrounds/bocchi_the_rock_city.jpg}"
      ];
      wallpaper = [
        "eDP-1,${../../assets/backgrounds/bocchi_the_rock_city.jpg}"
      ];
    };
  };
}

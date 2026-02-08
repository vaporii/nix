{ lib, config, ... }:

{
  options = {
    hyprpaper = {
      enable = lib.mkEnableOption "hyprpaper";
      monitors = lib.mkOption {
        type = with lib.types; listOf (submodule {
          options = {
            monitorName = lib.mkOption {
              type = types.str;
              description = "name of the monitor";
            };
            path = lib.mkOption {
              type = types.path;
              description = "path to the wallpaper to use for that monitor";
            };
          };
        });
        default = [
          {
            monitorName = "eDP-1";
            path = ../../assets/backgrounds/bocchi_the_rock_city.jpg;
          }
        ];
        description = "list of monitors and wallpapers";
      };
    };
  };
  
  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      preload = map (monitor: "${monitor.path}") config.hyprpaper.monitors;
      # wallpaper = [
      #   "eDP-1,${../../assets/backgrounds/bocchi_the_rock_city.jpg}"
      # ];
      wallpaper = map (monitor:
        {
          monitor = "${monitor.monitorName}";
          path = "${monitor.path}";
        }
      ) config.hyprpaper.monitors;
    };
  };
}

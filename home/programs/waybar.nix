{ lib, config, ... }:

{
  options = {
    waybar = {
      enable = lib.mkEnableOption "enable waybar module";
    };
  };

  config = lib.mkIf config.waybar.enable {
    programs.waybar.enable = true;
    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mode = "dock";
        height = 40;
        margin-left = 10;
        margin-right = 10;
        margin-top = 10;
        margin-bottom = 0;

        spacing = -10; # fucked up hack for the diagonals
        
        modules-left = [ "hyprland/workspaces" "tray" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "memory" "custom/end" "custom/start"
          "cpu" "custom/end" "custom/start"
          "temperature" "custom/end" "custom/start"
          "backlight" "custom/end" "custom/start"
          "network" "custom/end" "custom/start"
          "battery" "custom/end" "custom/start"
          "clock"
        ];

        "custom/start" = {
          format = " ";
        };

        "custom/end" = {
          format = " ";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "hyprland/window" = {
          max-length = 40;
        };

        clock = {
          format = "{:%I:%M %p}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-full = "{icon} {capacity}%";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰚥";

          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        temperature = {
          format = "󰔏 {temperatureC}°C";
        };

        cpu = {
          format = "󰍛 {usage}%";
        };

        memory = {
          format = " {}%";
        };

        network = {
          format-wifi = "󰤥 {essid}";
          tooltip-format = "signal strength: {signalStrength}%";
          format-disconnected = "󰤮 Disconnected";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" "" ];
        };
      };
    };

    programs.waybar.style = ./waybar/style.css;
  };
}

{ lib, config, ... }:

{
  options = {
    waybar = {
      enable = lib.mkEnableOption "enable waybar module";
      modulesRight = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "pulseaudio" "custom/end" "custom/start"
          "memory" "custom/end" "custom/start"
          "cpu" "custom/end" "custom/start"
          "temperature" "custom/end" "custom/start"
          "backlight" "custom/end" "custom/start"
          "network" "custom/end" "custom/start"
          "battery" "custom/end" "custom/start"
          "clock"
        ];
      };
      modulesCenter = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "custom/start" "hyprland/window" "custom/end" ];
      };
      modulesLeft = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "hyprland/workspaces" "custom/end" "custom/start" "tray" "custom/end" ];
      };
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "eDP-1" ];
        description = "monitors to display bar on";
      };
    };
  };

  config = lib.mkIf config.waybar.enable {
    programs.waybar.enable = true;
    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        output = config.waybar.monitors;
        position = "top";
        mode = "dock";
        height = 40;
        margin-left = 10;
        margin-right = 10;
        margin-top = 10;
        margin-bottom = 0;

        spacing = -10; # fucked up hack for the diagonals
        
        modules-left = config.waybar.modulesLeft;
        modules-center = config.waybar.modulesCenter;
        modules-right = config.waybar.modulesRight;

        "custom/start" = {
          format = " ";
        };

        "custom/end" = {
          format = " ";
        };

        "tray" = {
          spacing = 10;
        };

        "pulseaudio" = {
          format-icons = [ "" "" "" ];
          format-source-muted = " 0%";
          format = "{icon} {volume}%";
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

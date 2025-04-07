{ ... }:

{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 40;
      margin-left = 10;
      margin-right = 10;
      margin-top = 10;
      margin-bottom = 0;
      
      modules-left = [ "hyprland/workspaces" "tray" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "battery" "clock" ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
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
    };
  };

  programs.waybar.style = ./waybar/style.css;
}

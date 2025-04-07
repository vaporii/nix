{ ... }:

{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      margin-left = 10;
      margin-right = 10;
      margin-top = 10;
      margin-bottom = 0;
      
      modules-left = [ "hyprland/workspaces" ];
      modules-right = [ "clock" ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
      };

      clock = {
        format = "{:%I:%M %p}";
      };
    };
  };

  programs.waybar.style = ./waybar/style.css;
}

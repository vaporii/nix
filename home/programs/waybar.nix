{ ... }:

{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      
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
}

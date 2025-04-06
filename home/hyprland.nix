{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";

    bindle = [
      ", XF86MonBrightnessUp, exec, brightnessctl s +2%"
      ", XF86MonBrightnessDown, exec, brightnessctl s 2%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];
  
    bind = [
      # umm idk what to name these but they do something
      "$mod, RETURN, exec, $terminal"
      "$mod SHIFT, Q, killactive"
      "$mod, D, exec, rofi -show drun"

      # audio stuff
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"

      # window moving
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, J, movewindow, u"
      "$mod SHIFT, K, movewindow, d"
      "$mod SHIFT, L, movewindow, r"

      # focus moving
      "$mod, H, movefocus, l"
      "$mod, J, movefocus, u"
      "$mod, K, movefocus, d"
      "$mod, L, movefocus, r"
    ]
    ++ (
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]
      )
      9)
    );

    exec-once = [
      "waybar"
    ];

    monitor = ",1920x1080@60,0x0,1.25";

    general = {
      gaps_in = 5;
      gaps_out = 10;

      border_size = 1;

      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      resize_on_border = true;

      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      rounding_power = 2;

      active_opacity = 1.0;
      inactive_opacity = 0.9;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
        size = 3;
        passes = 1;

        vibrancy = 0.1696;
      };
    };

    animations = {
      enabled = true;

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ]; 
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master.new_status = "master";

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };

    input = {
      kb_layout = "us";
      
      follow_mouse = 1;

      sensitivity = 0;

      touchpad.natural_scroll = true;
    };
  };
}

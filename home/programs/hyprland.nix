{ pkgs, lib, config, ... }:

{
  options = {
    hyprland = {
      enable = lib.mkEnableOption "hyprland";
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "monitor settings";
        default = [",1920x1080@60,0x0,1,bitdepth,10,cm,auto"];
      };
    };
  };

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      package = null;
      portalPackage = null;
    };

    # wayland.windowManager.hyprland.plugins = [
    #   pkgs.hyprlandPlugins.hypr-dynamic-cursors
    # ];

    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      "$modalt" = "MOD3";
      "$terminal" = "${pkgs.kitty}/bin/kitty";

      bindle = [
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +2%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 2%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      windowrule = [
        "noborder, class:^flameshot$"
        "float, class:^flameshot$"
        "suppressevent fullscreen, class:^flameshot$"
        "move -1920 0, class:^flameshot$"
      ];

      # "plugin:dynamic-cursors" = {
      #   enabled = true;

      #   mode = "stretch";
      # };

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    
      bind = [
        # umm idk what to name these but they do something
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod, D, exec, ${pkgs.rofi}/bin/rofi -modi drun,run,window -show drun"
        "$mod SHIFT, S, exec, flameshot gui"

        # audio stuff
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"

        "$mod, F, fullscreen, 0"
        "$mod SHIFT, SPACE, togglefloating, active"

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

        # workspaces and shit
        "$modalt, D, workspace, name: "
        "$modalt, F, workspace, name: "

        "$modalt SHIFT, D, movetoworkspace, name: "
        "$modalt SHIFT, F, movetoworkspace, name: "
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
        "${pkgs.waybar}/bin/waybar"
      ];

      
      monitor = config.hyprland.monitors;
      # monitor = [",1920x1080@60,0x0,1,bitdepth,10,cm,auto"];

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        
        "col.active_border" = "rgba(665C54ff)";
        "col.inactive_border" = "rgba(665C547e)";

        resize_on_border = true;

        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        # rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 0.9;

        shadow.enabled = false;
        # shadow = {
        #   enabled = true;
        #   range = 4;
        #   render_power = 3;
        #   color = "rgba(1a1a1aee)";
        # };

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
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        
        follow_mouse = 1;

        sensitivity = 0;

        touchpad.natural_scroll = true;

        kb_options = "caps:hyper";
      };
    };
  };
}

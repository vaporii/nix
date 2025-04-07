{ pkgs, lib, ... }:

{
  programs.fastfetch = {
    package = (pkgs.fastfetch.overrideAttrs (finalAttrs: previousAttrs: {
      cmakeFlags = [(lib.cmakeBool "ENABLE_IMAGEMAGICK7" true)];
    }));
    
    settings = {
      logo = {
        type = "kitty";
        source = "$(ls ${../../assets/fastfetch}/*.png | shuf -n 1)";

        width = 33;
        height = 40;

        padding.left = 4;
        padding.right = 4;
      };

      display = {
        separator = "";
      };

      modules = [
        "break"
        "break"
        "break"
        "break"
        "break"
        "break"
        { type = "custom"; format = "                     ハードウェア                   "; }
        { type = "custom"; format = "╭────────────────────────────────────────────────────╮"; }

        { type = "cpu"; key = "│ CPU "; }
        { type = "gpu"; key = "  GPU "; format = "{2} [{6}]"; }
        { type = "memory"; key = "  MEM "; }
        { type = "battery"; key = "  BAT "; }
        "break"
        {
          type = "disk";
          folders = "/";
          key = "  󰋊 ";
        }

        { type = "custom"; format = "╰────────────────────────────────────────────────────╯"; }
        { type = "custom"; format = " 🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎"; }
        "break"

        { type = "custom"; format = "                     ソフトウェア                   "; }
        { type = "custom"; format = "╭────────────────────────────────────────────────────╮"; }

        { type = "title"; key = "│ 󰁥 "; format = "{1}@{2}"; }
        "break"
        { type = "os"; key = "   "; }
        { type = "kernel"; key = "  󰌽 "; format = "{1} {2}"; }
        { type = "packages"; key = "  󰆧 "; }
        "break"
        { type = "terminal"; key = "   "; }
        { type = "shell"; key = "  󱆃 "; }
#        { type = "font"; key = "  󰬈 "; }
        { type = "font"; key = "  󰬈 "; format = "Caskaydia Mono (8pt)"; }
        "break"
        { type = "wm"; key = "   "; }
#        { type = "theme"; key = "  󰏘 "; }
        { type = "theme"; key = "  󰏘 "; format = "bocchi"; }
        "break"
        { type = "media"; key = "  󰝚 "; }
        { type = "datetime"; key = "  󰃰 "; }

        { type = "custom"; format = "╰────────────────────────────────────────────────────╯"; }
        { type = "custom"; format = " 🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎🮎"; }
        "break"

        "colors"
      ];
    };
  };
}
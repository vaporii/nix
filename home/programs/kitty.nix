{ ... }:
let
  theme = import ../theme.nix;
in {
  programs.kitty.settings = let c = theme.colors; in {
    enable_audio_bell = false;
    confirm_os_window_close = 0;
    background_opacity = 0.8;

    # colors
    foreground = c.fg;
    background = c.bg;

    color0  = c.black;
    color1  = c.red;
    color2  = c.green;
    color3  = c.yellow;
    color4  = c.blue;
    color5  = c.magenta;
    color6  = c.cyan;
    color7  = c.white;

    color8  = c.brightBlack;
    color9  = c.brightRed;
    color10 = c.brightGreen;
    color11 = c.brightYellow;
    color12 = c.brightBlue;
    color13 = c.brightMagenta;
    color14 = c.brightCyan;
    color15 = c.brightWhite;


    color124 = c.brightRed;
    color106 = c.brightGreen;
    color172 = c.brightYellow;
    color66  = c.brightBlue;
    color132 = c.brightMagenta;
    color72  = c.brightCyan;

    color167 = c.red;
    color142 = c.green;
    color214 = c.yellow;
    color109 = c.blue;
    color175 = c.magenta;
    color108 = c.cyan;

    color234 = c.bg0;
    color237 = c.bg1;
    color239 = c.bg2;
    color241 = c.bg3;
    color243 = c.bg4;
    color245 = c.white;

    color246 = c.fg4;
    color248 = c.fg3;
    color250 = c.fg2;
    color223 = c.fg1;
    color229 = c.fg0;

    color166 = c.orange;
    color208 = c.brightOrange;

    color231 = c.accent;
  };
}

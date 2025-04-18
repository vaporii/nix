{ pkgs, config, lib, ... }:

{ 
  options.theme.enable = lib.mkEnableOption "visual theming";

  config = lib.mkIf config.theme.enable {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    gtk = {
      enable = true;

      iconTheme = {
        package = pkgs.gruvbox-plus-icons;
        name = "Gruvbox Dark";
      };

      theme = {
        package = pkgs.gruvbox-material-gtk-theme;
        name = "Gruvbox-Material-Dark";
      };
    };
  };
}

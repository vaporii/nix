{ pkgs, ... }:

{ 
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
  };
}

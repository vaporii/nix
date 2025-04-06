{ ... }:

{
  programs.fastfetch = {
    settings = {
      logo = {
        type = "kitty-direct";
        source = "$(ls ${../assets/fastfetch}/*.png | shuf -n 1)";

        width = 36;
        height = 32;

        padding.left = 4;
        padding.right = 4;
      };

      display = {
        separator = "";
      };
    };
  };
}
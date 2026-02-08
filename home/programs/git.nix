{ lib, config, ... }:

{
  options = {
    git = {
      enable = lib.mkEnableOption "enable git module";
    };
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "vaporii";
        user.email = "phi548182@gmail.com";
      };
    };
  };
}

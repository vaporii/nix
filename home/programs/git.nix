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
      userEmail = "phi548182@gmail.com";
      userName = "vaporii";
    };
  };
}

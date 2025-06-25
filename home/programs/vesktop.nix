{ lib, config, ... }:

{
  options = {
    vesktop = {
      enable = lib.mkEnableOption "enable vesktop module";
    };
  };

  config = lib.mkIf config.vesktop.enable {
    programs.vesktop = {
      enable = true;

      settings = {
        appBadge = true;
        arRPC = true;
        checkUpdates = false;
        customTitleBar = false;
        disableMinSize = true;
        minimizeToTray = true;
        tray = true;
        splashBackground = "#282828";
        splashColor = "#EBDBB2";
        splashTheming = true;
        staticTitle = true;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };
    };
  };
}
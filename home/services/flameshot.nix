{ pkgs, lib, config, ... }:

{
  options.flameshot.enable = lib.mkEnableOption "flameshot";

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      # package = (pkgs.flameshot.overrideAttrs (finalAttrs: previousAttrs: {
      #   cmakeFlags = [(lib.cmakeBool "USE_WAYLAND_GRIM" true)];
      # }));
      
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };
    };
  };
}

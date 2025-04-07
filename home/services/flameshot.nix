{ pkgs, lib, ... }:

{
  services.flameshot = {
    package = (pkgs.flameshot.overrideAttrs (finalAttrs: previousAttrs: {
      cmakeFlags = [(lib.cmakeBool "USE_WAYLAND_GRIM" true)];
    }));
    
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };
}
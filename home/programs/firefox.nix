{ inputs, ... }:

{
  programs.firefox = {
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab";
      FirefoxSuggest.SponsoredSuggestions = false;
      FirefoxHome = {
        SponsoredPocket = false;
        SponsoredTopSites = false;
      };
    };
    profiles.default = {
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
      ];
    };
  };
}

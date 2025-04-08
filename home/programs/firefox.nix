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
      search.default = "ddg";
      search.force = true;
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
      extensions = {
        packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          ublock-origin
          sponsorblock
          sidebery
        ];
      };
      userContent = ''
        * {
          border-radius: 0;
        }
      '';
    };
  };
}

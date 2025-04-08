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
          firefox-color
        ];
      };
      userChrome = ''
        * {
          border-radius: 0;
        }

        div#sidebar-wrapper vbox#sidebar-box.chromeclass-extrachrome {
          background: #282828 !important;
          margin-right: 2px !important;
        }

        body hbox#browser tabbox#tabbrowser-tabbox {
          background: #282828 !important;
        }

        hbox#browser tabbox#tabbrowser-tabbox::before {
          margin: -1.3rem 0rem !important;
        }

        toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target::before {
          margin: -1.0rem .4rem !important;
        }

        body toolbox#navigator-toolbox.browser-toolbox-background {
          background: #282828 !important;
        }
        
        html#main-window body hbox#browser {
          background: #282828 !important;
        }
      '';
    };
  };

  imports = [ inputs.textfox.homeManagerModules.default ];
  textfox = {
    enable = true;
    profile = "default";
  };
}

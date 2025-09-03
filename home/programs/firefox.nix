{ inputs, lib, config, ... }:

{
  imports = [ inputs.textfox.homeManagerModules.default ];

  options = {
    firefox = {
      enable = lib.mkEnableOption "enable firefox module";
      search = {
        default = lib.mkOption {
          type = lib.types.str;
          example = "ddg";
          default = "ddg";
          description = "default search engine";
        };
      };
    };
  };
  
  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
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
        search.default = config.firefox.search.default;
        search.force = true;
        settings = {
          "extensions.autoDisableScopes" = 0;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showWeather" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
        };
        extensions = {
          packages = with inputs.firefox-addons.packages."x86_64-linux"; [
            bitwarden
            ublock-origin
            sponsorblock
            firefox-color
          ];
        };
        # userChrome = ''
        #   * {
        #     border-radius: 0;
        #   }

        #   div#sidebar-wrapper vbox#sidebar-box.chromeclass-extrachrome {
        #     background: #282828 !important;
        #     margin-right: 2px !important;
        #   }

        #   body hbox#browser tabbox#tabbrowser-tabbox {
        #     background: #282828 !important;
        #   }

        #   hbox#browser tabbox#tabbrowser-tabbox::before {
        #     margin: -1.3rem 0rem !important;
        #   }

        #   toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target::before {
        #     margin: -1.0rem .4rem !important;
        #   }

        #   body toolbox#navigator-toolbox.browser-toolbox-background {
        #     background: #282828 !important;
        #   }
        #   
        #   html#main-window body hbox#browser {
        #     background: #282828 !important;
        #   }
        # '';
      };
    };

    textfox = {
      enable = true;
      profile = "default";
    };
  };
}

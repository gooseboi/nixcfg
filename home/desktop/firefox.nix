{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.desktop;
in {
  programs.firefox = lib.mkIf cfg.enable {
    enable = true;
    package = pkgs.librewolf;
    configPath = ".librewolf";

    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableMasterPasswordCreation = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
      };
      SearchEngines = {
        Add = [
          {
            Name = "Unduck";
            URLTemplate = "http://unduck.link?q={searchTerms}";
            Method = "GET";
            Alias = "@ud";
            IconUrl = "https://unduck.link/search.svg";
          }
        ];
        Default = "Unduck";
      };
      Preferences = lib.listToAttrs (lib.mapAttrsToList (n: v: {
          name = n;
          value = {
            Value = v;
            Status = "locked";
          };
        })
        {
          "browser.aboutConfig.showWarning" = false;
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.fullscreen.autohide" = false;
          "browser.tabs.warnOnClose" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.safebrowsing.provider.mozilla.updateURL" = null;
          # browser/components/preferences/main.js:1796 STARTUP_PREF_RESTORE_SESSION
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "about:home";
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              "widget-overflow-fixed-list" = [];
              "unified-extensions-area" = [];
              "nav-bar" = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "customizableui-special-spring1"
                "vertical-spacer"
                "urlbar-container"
                "customizableui-special-spring2"
                "downloads-button"
                "fxa-toolbar-menu-button"
                "unified-extensions-button"
              ];
              toolbar-menubar = ["menubar-items"];
              TabsToolbar = ["tabbrowser-tabs" "new-tab-button" "alltabs-button"];
              vertical-tabs = [];
              PersonalToolbar = ["personal-bookmarks"];
            };
            seen = ["developer-button"];
            dirtyAreaCache = [
              "nav-bar"
              "vertical-tabs"
              "toolbar-menubar"
              "TabsToolbar"
              "PersonalToolbar"
            ];
            currentVersion = 21;
            newElementCount = 2;
          };
          "browser.warnOnQuit" = false;
          "browser.warnOnQuitShortcut" = false;
          "media.eme.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "signon.management.page.breach-alerts.enabled" = false;
        });
    };

    profiles.chonk = {
      # Some setting are here cuz https://mozilla.github.io/policy-templates/#preferences
      # ie, not all preferences can be set through policy.
      settings = {
        "privacy.sanitize.pending" = [];
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
      };

      containers = {
        personal = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        shopping = {
          color = "pink";
          icon = "cart";
          id = 2;
        };
        google = {
          color = "yellow";
          icon = "fence";
          id = 3;
        };
        banking = {
          color = "green";
          icon = "dollar";
          id = 4;
        };
        anime = {
          color = "turquoise";
          icon = "chill";
          id = 5;
        };
        social = {
          color = "orange";
          icon = "gift";
          id = 6;
        };
        pron = {
          color = "purple";
          icon = "fruit";
          id = 7;
        };
      };
      containersForce = true;
    };
  };

  home.sessionVariables.BROWSER = "librewolf";
}

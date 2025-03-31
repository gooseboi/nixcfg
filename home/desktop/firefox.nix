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
          # Don't show warning when accessing about:config
          "browser.aboutConfig.showWarning" = false;

          # Ctrl-Tab scrolls recently used, not by tab order
          "browser.ctrlTab.sortByRecentlyUsed" = true;

          # Don't hide tabs when fullscreened
          "browser.fullscreen.autohide" = false;

          # Don't warn when closing multiple tabs (cuz we save them)
          "browser.tabs.warnOnClose" = false;

          # Always show bookmarks bar
          "browser.toolbars.bookmarks.visibility" = "always";

          # Disable safebrowsing
          "browser.safebrowsing.provider.mozilla.updateURL" = null;

          # Restore tabs when opening the browser, without asking
          # See browser/components/preferences/main.js:1796
          # STARTUP_PREF_RESTORE_SESSION in the firefox source code
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "about:home";

          # Set the layout of all the buttons
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

          # Don't show a dialong when quitting with closing button
          "browser.warnOnQuit" = false;

          # Don't show a dialong when quitting with shortcut
          "browser.warnOnQuitShortcut" = false;

          # Enable DRM
          "media.eme.enabled" = true;

          # Enable Global Privacy Control
          "privacy.globalprivacycontrol.enabled" = true;

          # Disable breach alerts
          "signon.management.page.breach-alerts.enabled" = false;
        });
    };

    profiles.chonk = {
      # Some setting are here cuz https://mozilla.github.io/policy-templates/#preferences
      # ie, not all preferences can be set through policy.
      settings = {
        "privacy.sanitize.pending" = [];

        "privacy.sanitize.sanitizeOnShutdown" = false;

        # Enable Containers
        "privacy.userContext.enabled" = true;

        # Always ask what container to use when using the mouse
        "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;

        # Don't ever show welcome screen
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

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

    profiles.chonk = {
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.fullscreen.autohide" = false;
        "browser.safebrowsing.provider.mozilla.updateURL" = null;
        "browser.tabs.warnOnClose" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
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
        "privacy.sanitize.pending" = [];
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.userContext.enabled" = true;
        "signon.management.page.breach-alerts.enabled" = false;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
      };

      search = {
        engines = {
          "Unduck" = {
            urls = [{template = ["https://unduck.link?q={searchTerms}"];}];
            icon = pkgs.fetchurl {
              url = "https://unduck.link/search.svg";
              sha256 = "sha256-fcI9HeFaMujs9HApnKEpgpygizY3m5jxAV070YXLJsM=";
            };
            definedAliases = ["@ud"];
          };
          "MetaGer".metadata.hidden = true;
          "Mojeek".metadata.hidden = true;
          "DuckDuckGo Lite".metadata.hidden = true;
        };
        force = true;
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
      };
      containersForce = true;
    };

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
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
      };
    };
  };
}

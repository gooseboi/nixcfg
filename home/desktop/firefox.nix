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

    profiles.chonk = {
      settings = {
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.fullscreen.autohide" = false;
        "privacy.userContext.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
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
              "save-to-pocket-button"
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
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.safebrowsing.provider.mozilla.updateURL" = null;
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

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
    profiles.chonk = {
      settings = {
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.fullscreen.autohide" = false;
        "privacy.userContext.enabled" = true;
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

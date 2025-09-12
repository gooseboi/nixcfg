{
  pkgs,
  lib,
  systemConfig,
  ...
}: let
  inherit (lib) iota listToAttrs mapAttrsToList;

  inherit (systemConfig.chonkos) theme;
in {
  programs.firefox = let
    locked = attrs: attrs // {Locked = true;};
  in {
    enable = true;
    package = pkgs.librewolf;
    configPath = ".librewolf";

    # https://mozilla.github.io/policy-templates/#preferences
    # about:policies#documentation
    policies = {
      # TODO: Disable translation

      # No app updates
      DisableAppUpdate = true;
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # No autofill
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;

      # Remove all integration with any mozilla service
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableMasterPasswordCreation = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableTelemetry = true;
      FirefoxSuggest = locked {
        ImproveSuggest = false;
        SponsoredSuggestions = false;
        WebSuggestions = false;
      };

      # I don't care what you have to say
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
      };

      # I can set this myself, thank you
      DontCheckDefaultBrowser = true;

      # I don't care
      NoDefaultBookmarks = true;

      # Yeah
      PictureInPicture = locked {
        Enabled = false;
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

      # To find the `shortId`, go to the extension page on addons.mozilla.
      # To find the `uuid`, install it imperatively and then go to "about:support#addons"
      ExtensionSettings = let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
        listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "600-sound-volume" "{c4b582ec-4343-438c-bda2-2f691c16c262}")
          (extension "ctrl-number-to-switch-tabs" "{84601290-bec9-494a-b11c-1baa897a9683}")
          (extension "cookies-txt" "{12cf650b-1822-40aa-bff0-996df6948878}")
        ];

      Preferences =
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
              "unified-extensions-area" = [
                "_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action"
                "_12cf650b-1822-40aa-bff0-996df6948878_-browser-action"
                "_84601290-bec9-494a-b11c-1baa897a9683_-browser-action"
              ];
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
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                "ublock0_raymondhill_net-browser-action"
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
            currentVersion = 23;
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
        }
        |> mapAttrsToList (n: v: {
          name = n;
          value = {
            Value = v;
            Status = "locked";
          };
        })
        |> listToAttrs;
    };

    profiles.chonk = {
      # Some setting are here cuz https://mozilla.github.io/policy-templates/#preferences
      # ie, not all preferences can be set through policy.
      settings = let
        fontSize = 1.1 * theme.font.size.normal |> builtins.ceil;
      in {
        "privacy.sanitize.pending" = [];

        "privacy.sanitize.sanitizeOnShutdown" = false;

        # Enable Containers
        "privacy.userContext.enabled" = true;

        # Always ask what container to use when using the mouse
        "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;

        # Don't ever show welcome screen
        "trailhead.firstrun.didSeeAboutWelcome" = true;

        # Font to use
        "font.name.serif.x-western" = theme.font.sans.name;
        "font.name.monospace.x-western" = theme.font.mono.name;

        # Font size
        "font.size.variable.x-western" = fontSize;
        "font.size.monospace.x-western" = fontSize;
        "font.minimum-size.x-western" = fontSize;
      };

      containers = let
        containers = [
          {
            name = "personal";
            color = "blue";
            icon = "fingerprint";
          }
          {
            name = "shopping";
            color = "pink";
            icon = "cart";
          }
          {
            name = "google";
            color = "yellow";
            icon = "fence";
          }
          {
            name = "banking";
            color = "green";
            icon = "dollar";
          }
          {
            name = "anime";
            color = "turquoise";
            icon = "chill";
          }
          {
            name = "social";
            color = "orange";
            icon = "gift";
          }
          {
            name = "pron";
            color = "purple";
            icon = "fruit";
          }
          {
            name = "games";
            color = "blue";
            icon = "chill";
          }
        ];
      in
        lib.zipListsWith (
          cont: id: {
            inherit (cont) name;
            value = {
              inherit (cont) color icon;
              inherit id;
            };
          }
        )
        containers
        (iota {
          base = 1;
          # Hardcoded cuz i'm like that
          n = 100;
        })
        |> listToAttrs;
      containersForce = true;

      extensions = {
        force = true;
        settings = {
          "uBlock0@raymondhill.net" = {
            # Home-manager skip collision check
            settings = {
              user-filters = ''
                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! www.youtube.com
                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                ! Title: Hide YouTube Shorts
                ! Description: Hide all traces of YouTube shorts videos on YouTube
                ! Version: 1.10.0
                ! Last modified: 2024-08-31 19:24
                ! Expires: 2 weeks (update frequency)
                ! Homepage: https://github.com/gijsdev/ublock-hide-yt-shorts
                ! License: https://github.com/gijsdev/ublock-hide-yt-shorts/blob/master/LICENSE.md

                ! Remove empty spaces in grid
                www.youtube.com##ytd-rich-grid-row,#contents.ytd-rich-grid-row:style(display: contents !important)

                ! Hide all videos containing the phrase "#shorts"
                www.youtube.com##ytd-grid-video-renderer:has(#video-title:has-text(/(^| )#Shorts?( |$)/i))
                www.youtube.com##ytd-rich-item-renderer:has(#video-title:has-text(/(^| )#Shorts?( |$)/i))

                ! Hide all videos with the shorts indicator on the thumbnail
                www.youtube.com##ytd-grid-video-renderer:has([overlay-style="SHORTS"])
                www.youtube.com##ytd-rich-item-renderer:has([overlay-style="SHORTS"])
                www.youtube.com##ytd-video-renderer:has([overlay-style="SHORTS"])
                www.youtube.com##ytd-item-section-renderer.ytd-section-list-renderer[page-subtype="subscriptions"]:has(ytd-video-renderer:has([overlay-style="SHORTS"]))

                ! Hide shorts button in sidebar
                www.youtube.com##ytd-guide-entry-renderer:has(yt-formatted-string:has-text(/^Shorts$/i))
                ! Tablet resolution
                www.youtube.com##ytd-mini-guide-entry-renderer:has(.title:has-text(/^Shorts$/i))

                ! Hide shorts sections except on history page
                www.youtube.com##:matches-path(/^(?!\/feed\/history).*$/)ytd-rich-section-renderer:has(#title:has-text(/(^| )Shorts( |$)/i))
                www.youtube.com##:matches-path(/^(?!\/feed\/history).*$/)ytd-reel-shelf-renderer:has(.ytd-reel-shelf-renderer:has-text(/(^| )Shorts( |$)/i))

                ! Hide shorts tab on channel pages`
                ! Old style
                www.youtube.com##tp-yt-paper-tab:has(.tp-yt-paper-tab:has-text(Shorts))
                ! New style (2023-10)
                www.youtube.com##yt-tab-shape:has-text(/^Shorts$/)

                ! Hide short remixes in video descriptions and in suggestions beside the comments
                www.youtube.com##ytd-reel-shelf-renderer:has(#title:has-text(/(^| )Shorts.?Remix.*$/i))

                ! Hide shorts category on homepage and search pages
                www.youtube.com##yt-chip-cloud-chip-renderer:has(yt-formatted-string:has-text(/^Shorts$/i))

                !!! MOBILE !!!

                ! Hide all videos in home feed containing the phrase "#shorts"
                www.youtube.com##ytm-rich-item-renderer:has(#video-title:has-text(/(^| )#Shorts?( |$)/i))

                ! Hide all videos in subscription feed containing the phrase "#shorts"
                m.youtube.com##ytm-item-section-renderer:has(#video-title:has-text(/(^| )#Shorts?( |$)/i))

                ! Hide shorts button in the bottom navigation bar
                m.youtube.com##ytm-pivot-bar-item-renderer:has(.pivot-shorts)

                ! Hide all videos with the shorts indicator on the thumbnail
                m.youtube.com##ytm-video-with-context-renderer:has([data-style="SHORTS"])

                ! Hide shorts sections except on history page
                m.youtube.com##:matches-path(/^(?!\/feed\/history).*$/)ytm-rich-section-renderer:has(.reel-shelf-title-wrapper .yt-core-attributed-string:has-text(/(^| )Shorts( |$)/i))
                m.youtube.com##:matches-path(/^(?!\/feed\/history).*$/)ytm-reel-shelf-renderer.item:has(.reel-shelf-title-wrapper .yt-core-attributed-string:has-text(/(^| )Shorts( |$)/i))

                ! Hide shorts tab on channel pages
                ! Old style
                m.youtube.com##.single-column-browse-results-tabs>a:has-text(Shorts)
                ! New style (2023-10)
                m.youtube.com##yt-tab-shape:has-text(/^Shorts$/)

                ! Hide short remixes in video descriptions and in suggestions below the player
                m.youtube.com##ytm-reel-shelf-renderer:has(.reel-shelf-title-wrapper .yt-core-attributed-string:has-text(/(^| )Shorts.?Remix.*$/i))

                ! Hide shorts category on homepage
                m.youtube.com##ytm-chip-cloud-chip-renderer:has(.yt-core-attributed-string:has-text(/^Shorts$/i))

                ! Aug 20, 2025
                www.youtube.com###voice-search-button
                www.youtube.com###guide
                www.youtube.com##ytd-mini-guide-renderer.ytd-app.style-scope
                www.youtube.com###guide-button




                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! https://hypnohub.net
                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! Jun 25, 2025
                hypnohub.net##[href^="https://s.zlink0.com/v1/d.php"]



                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! https://ftbwiki.org
                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! Aug 13, 2025
                ftbwiki.org##.cc-nb-main-container



                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! https://x.com
                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! Aug 13, 2025
                x.com##a.r-1loqt21.r-1ny4l3l.r-13qz1uu.r-cnw61z.r-1habvwh.r-16y2uox.r-eqz5dr.r-6koalj.css-175oi2r:nth-of-type(5)
                x.com##a.r-1loqt21.r-1ny4l3l.r-13qz1uu.r-cnw61z.r-1habvwh.r-16y2uox.r-eqz5dr.r-6koalj.css-175oi2r:nth-of-type(10)
                x.com##a.r-1loqt21.r-1ny4l3l.r-13qz1uu.r-cnw61z.r-1habvwh.r-16y2uox.r-eqz5dr.r-6koalj.css-175oi2r:nth-of-type(9)
                ! Aug 20, 2025
                x.com##.r-1wtj0ep.r-1cmwbt1.r-18u37iz.r-1awozwy.css-175oi2r > .r-1h0z5md.r-18u37iz.css-175oi2r > .r-1ny4l3l.r-1loqt21.r-lrvibr.r-bztko3.r-bt1l66.r-1777fci.css-175oi2r > .r-3s2u2q.r-clp7b1.r-o7ynqc.r-1h0z5md.r-6koalj.r-1awozwy.r-16dba41.r-rjixqe.r-a023e6.r-37j5jr.r-qvutc0.r-1ttztb7.r-bcqeeo.css-146c3p1 > .r-xoduu5.css-175oi2r > .r-1hdv0qi.r-1xvli5t.r-m6rgpd.r-lrvibr.r-bnwqim.r-dnmrzs.r-yyyyoo.r-4qtqp9
                x.com##.r-3pj75a.r-1mmae3n.r-1ssbvtb.r-1habvwh.css-175oi2r
                x.com##.r-rs99b7.r-1q9bdsx.r-18bvks7.r-yfoy6g.css-175oi2r
                x.com##div.r-1udh08x.r-1ifxtd0.r-rs99b7.r-1phboty.r-1867qdf.r-18bvks7.r-yfoy6g.css-175oi2r:nth-of-type(5)



                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! https://www.amazon.com
                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ! Aug 19, 2025
                www.amazon.com##.bia-content.a-box
                www.amazon.com###CardInstanceHDEZim6C7U-4os0c7QYv_g > .a-text-normal.image-window.aok-block._cropped-image-link_style_centerImage-focusable__1JvMN._cropped-image-link_style_centerImage__1rzYI.a-link-normal
                www.amazon.com###gw-ftGr-desktop-hero-1 > ._cropped-image-link_style_cropped-image-link__3winf.a-spacing-none.a-section
                www.amazon.com##.a-carousel
                www.amazon.com##.gw-desktop-herotator-ready.tall.aok-relative.a-spacing-none.a-section
                ! Aug 29, 2025
                www.amazon.com##.nav-flyout-sidePanel
              '';
            };
          };
        };
      };
    };
  };

  home.sessionVariables.BROWSER = "librewolf";
}

{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.firefox;
in {
  options.my.graphical.firefox = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableProfileImport = true;
          DisplayBookmarksToolbar = "never";
          NoDefaultBookmarks = true;
          DontCheckDefaultBrowser = true;
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
          ExtensionSettings = let
            mozillaExtensions = {
              buster-captcha-solver = "{e58d3966-3d76-4cd9-8552-1582fbc800c1}";
              clearurls = "{74145f27-f039-47ce-a470-a662b129930a}";
              search_by_image = "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}";
              styl-us = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
              traduzir-paginas-web = "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}";
              violentmonkey = "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}";
              firenvim = "firenvim@lacamb.re";
              sponsorblock = "sponsorBlocker@ajay.app";
              tabcenter-reborn = "tabcenter-reborn@ariasuni";
              ublock-origin = "uBlock0@raymondhill.net";
            };
            otherExtensions = {
              "{409be3b6-54bf-47c8-83d2-9bd43e0730e3}" =
                "https://github.com/catppuccin/firefox/releases/download/old/catppuccin_mocha_teal.xpi";
            };
          in builtins.mapAttrs (_: url: {
            install_url = url;
            installation_mode = "force_installed";
          }) (lib.mapAttrs' (name: id:
            lib.nameValuePair id "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi"
          ) mozillaExtensions // otherExtensions);
        };
      };
      profiles.errie = {
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.ctrlTab.sortByRecentlyUsed" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.pinned" = [];
          "browser.startup.page" = 3;
          "cookiebanners.service.mode" = 1;
          "cookiebanners.service.mode.privateBrowsing" = 1;
          "devtools.selfxss.count" = 100;
          "privacy.webrtc.legacyGlobalIndicator" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "ui.key.menuAccessKeyFocuses" = false;
          "browser.uiCustomization.state" = ''
          {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","firenvim_lacamb_re-browser-action","sponsorblocker_ajay_app-browser-action","ublock0_raymondhill_net-browser-action","_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","tabcenter-reborn_ariasuni-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action","_e58d3966-3d76-4cd9-8552-1582fbc800c1_-browser-action","developer-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","_e58d3966-3d76-4cd9-8552-1582fbc800c1_-browser-action","firenvim_lacamb_re-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action","sponsorblocker_ajay_app-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","tabcenter-reborn_ariasuni-browser-action","ublock0_raymondhill_net-browser-action","_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar"],"currentVersion":18,"newElementCount":7}
        '';
        };
        search = {
          default = "DuckDuckGo";
          force = true;
          order = [ "DuckDuckGo" "SearXNG" "Google" ];
          engines = {
            "SearXNG" = {
              definedAliases = [ "@searxng" ];
              icon = ../../../assets/searxng.svg;
              urls = [{
                template = "https://etsi.me/search";
                params = [{
                  name = "q";
                  value = "{searchTerms}";
                }];
              }];
            };
            "Nix Packages" = {
              definedAliases = [ "@nixpkgs" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
            };
          } // lib.genAttrs [ "Bing" "Amazon.com" "eBay" ] (_: {metaData.hidden = true;});
        };
        userChrome = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "ranmaru22";
          repo = "firefox-vertical-tabs";
          rev = "v5.9";
          sha256 = "1nm0lff4yc331pn6hfhgnd1dkwfb97krjp018vpwblxmafmwniy7";
        } + "/userChrome.css");
      };
    };
  };
}

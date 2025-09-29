{ ... }: {
  default = {
    # These settings are an alternation from arkenfox
    # https://github.com/arkenfox/user.js/blob/master/user.js

    # startup page
    "browser.startup.page" = 3; # try resume previous
    "browser.startup.homepage" = "localhost";

    # remove sponsored content
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    # Geo location
    # "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;

    # Quieter Fox
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = true;
    "browser.shopping.experience2023.enabled" = false;

    # Telemetry
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.ping-centre.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;

    # Studies
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    # Crash reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

    # Other
    # "captivedetect.canonicalURL" = "";
    # "network.captive-portal-service.enabled" = false;
    # "network.connectivity-service.enabled" = false;

    # Safe Browsing
    "browser.safebrowsing.downloads.remote.enabled" = false;

    # Block implicit outbound
    "network.prefetch-next" = true;
    "network.dns.disablePrefetch" = true;
    "network.predictor.enabled" = true;
    "network.predictor.enable-prefetch" = true;
    "network.http.speculative-parallel-limit" = 10;
    "browser.places.speculativeConnect.enabled" = true;

    # DNS / DoH / PROXY / SOCKS
    "network.proxy.socks_remote_dns" = true;
    "network.file.disable_unc_paths" = true;
    "network.gio.supported-protocols" = "";

    # LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
    "browser.urlbar.speculativeConnect.enabled" = true;
    "browser.urlbar.trending.featureGate" = false;
    "browser.urlbar.addons.featureGate" = false;
    "browser.urlbar.pocket.featureGate" = false;
    "browser.urlbar.weather.featureGate" = false;
    "browser.formfill.enable" = true;
    "browser.search.separatePrivateDefault" = false; # CHANGED
    "browser.search.separatePrivateDefault.ui.enabled" = true;
    "places.history.enabled" = true;

    # Passwords
    "signon.autofillForms" = false;
    "signon.formlessCapture.enabled" = false;
    "signon.rememberSignons" = false; # disable password saving
    "network.auth.subresource-http-auth-allow" = 1;

    # Disk Avoidance
    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "toolkit.winRegisterApplicationRestart" = false;
    "browser.shell.shortcutFavicons" = false;

    # HTTPS
    "security.ssl.require_safe_negotiation" = true;
    "security.tls.enable_0rtt_data" = true;
    "security.OCSP.enabled" = 1;
    "security.OCSP.require" = true;
    "security.cert_pinning.enforcement_level" = 2;
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.pki.crlite_mode" = 2;

    # Mixed Content
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_send_http_background_request" = false;
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.xul.error_pages.expert_bad_cert" = true;

    # Referers
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # Containers
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;

    # Plugins / Media / WebRTC
    "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
    "media.peerconnection.ice.default_address_only" = true;

    # DOM
    # "dom.disable_window_move_resize" = true;

    # Misc
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.uitour.enabled" = true;
    "devtools.debugger.remote-enabled" = false;
    "permissions.manager.defaultsUrl" = "";
    "webchannel.allowObject.urlWhitelist" = "";
    "network.IDN_show_punycode" = true;
    "pdfjs.disabled" = false;
    "pdfjs.enableScripting" = false;
    "browser.tabs.searchclipboardfor.middleclick" = false;

    # Downloads
    "browser.download.useDownloadDir" = false;
    "browser.download.alwaysOpenPanel" = false;
    "browser.download.manager.addToRecentDocs" = true;
    "browser.download.always_ask_before_handling_new_types" = true;

    # Enhanced Tracking Protection
    "browser.contentblocking.category" = "strict";

    # Sanitize on Shutdown
    "privacy.sanitize.sanitizeOnShutdown" = false;
    "privacy.clearOnShutdown.cache" = false;

    # Ignore "ALLOW" site exception
    "privacy.cpd.cache" = false; # CHANGED
    "privacy.cpd.formdata" = true;
    "privacy.cpd.history" = true;
    "privacy.cpd.sessions" = false; # CHANGED
    "privacy.cpd.offlineApps" = false; # CHANGED
    "privacy.cpd.cookiesApps" = false; # CHANGED
    "privacy.sanitize.timeSpan" = 0;

    # FPP
    "privacy.resistFingerprinting" = true;
    #"privacy.window.maxInnerWidth" = 1600; # CHANGED
    #"privacy.window.maxInnerHeight" = 900; # CHANGED
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    "privacy.resistFingerprinting.letterboxing" = true;
    "browser.display.use_system_colors" = true;
    "widget.non-native-theme.enabled" = true;
    "browser.link.open_newwindow" = 3;
    "browser.link.open_newwindow.restriction" = 0;
    "webgl.disabled" = false; # false if Netflix/Streaming is needed

    # Don't touch
    "extensions.blocklist.enabled" = true;
    "network.http.referer.spoofSource" = false;
    "security.dialog_enable_delay" = 1000;
    "privacy.firstparty.isolate" = false;
    "extensions.webcompat.enable_shims" = true;
    "security.tls.version.enable-deprecated" = false;
    "extensions.webcompat-reporter.enabled" = false;
    "extensions.quarantinedDomains.enabled" = true;

    # non-project related
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
      false;
    "browser.messaging-system.whatsNewPanel.enabled" = false;
    "browser.urlbar.showSearchTerms.enabled" = true;
  };
}

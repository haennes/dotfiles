{ config, pkgs, ... }: {

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;

    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
      edge-tiling = true;
    };

    "org/gnome/shell/app-swither" = { current-workspace-only = false; };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "brave-browser.desktop"
        "writer.desktop"
      ];
      disable-user-extensions = false;

      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      preffered-monitor-by-connector = "HDMI-1";
      dock-position = "BOTTOM";
      dock-fixed = false;
      extend-height = false;
      height-fraction = 0.9;
      dash-max-icon-size = 48;
      preview-size-scale = 0;
      show-favorites = true;
      show-running = true;
      show-windows-preview = true;
      isolate-workspaces = false;
      workspace-agnostic-urgent-windows = true;
      isolate-monitors = false;
      show-show-apps-button = true;
      show-apps-at-top = false;
      animate-show-apps = true;
      show-apps-always-in-the-edge = true;
      show-trash = false;
      show-mounts = true;
      show-mounts-only-mounted = true;
      dance-urgent-applications = true;
      hide-tooltip = true;
      show-icons-emblems = true;
      show-icons-notifications-counter = true;
      application-counter-overrides-notifications = true;
      click-action = "focus-minimize-or-previews";
      scroll-action = "cycle-windows";
      custom-theme-shrink = false;
      disable-overview-on-startup = false;
      apply-custom-theme = true;
    };
    "org/gnome/shell/extensions/gsnap" = { show-tabs = false; };

    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      recursive-search = "local-only";
      show-image-thumbnails = "always";
      show-directory-item-counts = "local-only";
      click-policy = "double";
    };

    "org/gnome/nautilus/icon-view" = { captions = [ "none" "none" "none" ]; };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      sort-directories-first = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      nigth-light-enabled = true;
      nigth-light-schedule-automatic = false;
      nigth-light-schedule-from = 13.0;
      nigth-light-schedule-to = 13.0;
      nigth-light-temperature = 1700;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
    };
  };
}

# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      item-filter = "any";
      keyrings-selected = [ "secret-service:///org/freedesktop/secrets/collection/login" ];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 594;
      width = 1215;
    };

    "com/gexperts/Tilix" = {
      terminal-title-style = "small";
      theme-variant = "dark";
    };

    "com/gexperts/Tilix/keybindings" = {
      app-new-session = "<Alt>n";
      app-new-window = "disabled";
      nautilus-open = "disabled";
      session-add-auto = "<Alt>a";
      session-add-down = "disabled";
      session-add-right = "disabled";
      session-close = "disabled";
      session-open = "disabled";
      session-resize-terminal-down = "disabled";
      session-resize-terminal-left = "disabled";
      session-resize-terminal-right = "disabled";
      session-resize-terminal-up = "disabled";
      session-save = "disabled";
      session-switch-to-next-terminal = "<Alt>period";
      session-switch-to-previous-terminal = "<Alt>comma";
      terminal-close = "disabled";
      terminal-copy = "<Primary><Shift>c";
      terminal-find-next = "<Primary>greater";
      terminal-find-previous = "<Primary>less";
      terminal-maximize = "disabled";
      terminal-page-down = "disabled";
      terminal-page-up = "disabled";
      terminal-paste = "<Primary><Shift>v";
      win-reorder-next-session = "<Shift><Alt>j";
      win-reorder-previous-session = "<Shift><Alt>k";
      win-switch-to-next-session = "<Alt>j";
      win-switch-to-previous-session = "<Alt>k";
    };

    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      background-color = "#1A1B26";
      background-transparency-percent = 0;
      badge-color-set = false;
      bold-color-set = false;
      cursor-colors-set = false;
      foreground-color = "#A9B1D6";
      highlight-colors-set = false;
      palette = [ "#1A1B26" "#F7768E" "#9ECE6A" "#E0AF68" "#7AA2F7" "#BB9AF7" "#73DACA" "#A9B1D6" "#565F89" "#F7768E" "#9ECE6A" "#E0AF68" "#7AA2F7" "#BB9AF7" "#73DACA" "#CFC9C2" ];
      use-theme-colors = false;
      visible-name = "Default";
    };

    "org/freedesktop/tracker/miner/files" = {
      index-recursive-directories = [ "&DESKTOP" "&DOCUMENTS" "&MUSIC" "&PICTURES" "&VIDEOS" "&DOWNLOAD" ];
    };

    "org/gnome/Console" = {
      last-window-size = mkTuple [ 652 480 ];
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [ 960 600 ];
    };

    "org/gnome/control-center" = {
      last-panel = "keyboard";
      window-state = mkTuple [ 980 640 false ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" "Pardus" ];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = [ "X-Pardus-Apps" ];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [ (mkTuple [ "xkb" "us" ]) ];
      sources = [ (mkTuple [ "xkb" "gb" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "compose:ralt" "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      document-font-name = "Inter 11";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Inter Medium 10";
      icon-theme = "Papirus-Dark";
      monospace-font-name = "Iosevka Nerd Font Medium 10";
      show-battery-percentage = true;
      text-scaling-factor = 0.98;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "gnome-power-panel" "org-gnome-console" "firefox" "org-gnome-characters" "thunderbird" "anki" ];
    };

    "org/gnome/desktop/notifications/application/anki" = {
      application-id = "anki.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-characters" = {
      application-id = "org.gnome.Characters.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/thunderbird" = {
      application-id = "thunderbird.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.0;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ "org.gnome.Epiphany.desktop" ];
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Calculator.desktop" "org.gnome.Calendar.desktop" "org.gnome.clocks.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.Settings.desktop" "org.gnome.Characters.desktop" "org.gnome.Weather.desktop" "org.gnome.Epiphany.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/wm/keybindings" = {
      begin-move = [];
      begin-resize = [];
      close = [ "<Super>q" ];
      switch-applications = [ "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" ];
      switch-group = [ "<Alt>grave" ];
      switch-group-backward = [ "<Shift><Alt>grave" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Inter Medium 10";
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "processes";
      maximized = true;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 1080 1920 0 0 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      col-0-visible = true;
      col-0-width = 265;
      columns-order = [ 0 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 ];
      sort-col = 15;
      sort-order = 0;
    };

    "org/gnome/mutter" = {
      edge-tiling = false;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small";
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      maximized = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      email = [ "<Super>e" ];
      help = [];
      home = [ "<Super>f" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "tilix";
      name = "Launch Tilix";
    };

    "org/gnome/shell" = {
      enabled-extensions = [ "clipboard-indicator@tudmotu.com" "espresso@coadmunkee.github.com" "tiling-assistant@leleat-on-github" ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "45.2";
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      display-mode = 0;
      history-size = 30;
      move-item-first = true;
      preview-size = 60;
      strip-text = true;
    };

    "org/gnome/shell/extensions/espresso" = {
      has-battery = true;
      user-enabled = true;
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      activate-layout0 = [];
      activate-layout1 = [];
      activate-layout2 = [];
      activate-layout3 = [];
      active-window-hint = 1;
      active-window-hint-color = "rgb(53,132,228)";
      active-window-hint-inner-border-size = 2;
      auto-tile = [];
      center-window = [];
      debugging-free-rects = [];
      debugging-show-tiled-rects = [];
      default-move-mode = 1;
      dynamic-keybinding-behavior = 0;
      enable-advanced-experimental-features = true;
      import-layout-examples = false;
      last-version-installed = 44;
      restore-window = [];
      search-popup-layout = [ "<Shift><Alt>l" ];
      tile-bottom-half = [ "<Shift><Alt>s" ];
      tile-bottom-half-ignore-ta = [];
      tile-bottomleft-quarter = [ "<Shift><Alt>z" ];
      tile-bottomleft-quarter-ignore-ta = [];
      tile-bottomright-quarter = [ "<Shift><Alt>c" ];
      tile-bottomright-quarter-ignore-ta = [];
      tile-edit-mode = [ "<Shift><Alt>t" ];
      tile-left-half = [ "<Shift><Alt>a" ];
      tile-left-half-ignore-ta = [];
      tile-maximize = [ "<Shift><Alt>f" ];
      tile-maximize-horizontally = [];
      tile-maximize-vertically = [];
      tile-right-half = [ "<Shift><Alt>d" ];
      tile-right-half-ignore-ta = [];
      tile-top-half = [ "<Shift><Alt>w" ];
      tile-top-half-ignore-ta = [];
      tile-topleft-quarter = [ "<Shift><Alt>q" ];
      tile-topleft-quarter-ignore-ta = [];
      tile-topright-quarter = [ "<Shift><Alt>e" ];
      tile-topright-quarter-ignore-ta = [];
      toggle-always-on-top = [];
      toggle-tiling-popup = [];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 140;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple [ 815 366 ];
    };

  };
}

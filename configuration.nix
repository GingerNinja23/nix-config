{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;

      ApplePressAndHoldEnabled = false;              # holding a key repeats it instead of showing the accent popup
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;   # no smart quotes
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;  # no period on double-space

      NSWindowShouldDragOnGesture = true;            # ctrl+cmd+drag a window from anywhere

      NSNavPanelExpandedStateForSaveMode = true;     # save dialogs open expanded
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;        # print dialogs open expanded
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;     # default save location is disk, not iCloud
    };
    dock = {
      autohide = true;
      showAppExposeGestureEnabled = true;  # swipe down with three fingers for App Exposé
      autohide-delay = 0.0;                # hidden dock appears instantly
      autohide-time-modifier = 0.4;        # faster show/hide animation
      show-recents = false;                # no "recent apps" section
      mru-spaces = false;                  # don't auto-reorder Spaces by recent use
      tilesize = 48;
    };
    finder = {
      FXPreferredViewStyle = "Nlsv";       # list view by default
      #CreateDesktop = false;               # clean desktop
      AppleShowAllFiles = true;            # show hidden/dotfiles
      ShowPathbar = true;                  # breadcrumb path at the bottom
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXDefaultSearchScope = "SCcf";       # search the current folder, not "This Mac"
      _FXShowPosixPathInTitle = true;      # full path in the window title
    };
    trackpad = {
      Clicking = true;                     # tap to click
      TrackpadThreeFingerDrag = true;      # drag windows with three fingers
    };
    screencapture.location = "~/Screenshots";  # stop cluttering the Desktop
  };
  # mas v7 installs apps by re-executing itself via sudo
  # (`sudo MAS_NO_AUTO_INDEX=1 <mas-binary> install ...`), so the NOPASSWD
  # rule must cover the mas binary itself, with SETENV for the env prefix.
  environment.etc."sudoers.d/mas".text = ''
    ${user} ALL=(ALL) NOPASSWD:SETENV: /opt/homebrew/Cellar/mas/*/libexec/bin/mas
  '';

  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";  # remove unlisted formulae, but respect dependency graph
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "gh"
      "herdr"
      "awscli"
      "btop"
      "ffmpeg"
      "mise"
      "neovim"
      "node"
    ];
    casks = [
      "android-platform-tools"
      "ghostty"
      "raycast"
      "t3-code"
      "cmux"
      "supaterm"
      "supacode"
      "zen"
      "visual-studio-code"
      "postman"
      "obsidian"
      "chatgpt"
      "rectangle"
      "shottr"
      "cotypist"
      "spotify"
    ];
    masApps = {
      "Things 3" = 904280696;
      "Bear" = 1091189122;
      "AutoMute - No More Oopsies" = 1118136179;
      "WhatsApp Messenger" = 310633997;
      "Apple Configurator" = 1037126344;
    };
  };
}

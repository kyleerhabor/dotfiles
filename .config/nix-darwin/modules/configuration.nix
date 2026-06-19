{ pkgs, inputs, ... }: let
  organizationID = "com.kyleerhabor";
  homeDirectory = "/Users/kyleerhabor";

  # Paths
  logDirectory = "${homeDirectory}/Library/Logs";
  navidromeConfigurationFile = pkgs.writeText "navidrome-config.toml" (builtins.readFile ./configuration/resources/navidrome/navidrome.toml);

  # Daemons
  navidromeDaemonID = "${organizationID}.navidrome";
  navidromeDaemonStandardFile = "${logDirectory}/${navidromeDaemonID}.access.log";
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # For some reason, including vscode causes Nix to pull in glibc, which is unsupported.
  #
  # python313 exists, but I can't use pip to install packages, which is bad for packages like yt-dlp which regularly update.
  environment.systemPackages = with pkgs; [
    (clojure.override { jdk = temurin-bin-25; })
    fastfetch # I don't know what the difference is between this and fastfetchMinimal.
    ffmpeg-full
    lua54Packages.fennel
    mediainfo
    mpv
    neovim-unwrapped
    nixd
    # nodejs_24
    nushell
    pyenv
    rustup
    smartmontools
    sqlitebrowser
    # subversion # Used to clone XLD once.
    tree
    # unrar
    vscode
  ];
  
  # Navidrome
  launchd.user.agents.navidrome.serviceConfig.Label = navidromeDaemonID;
  launchd.user.agents.navidrome.serviceConfig.ProgramArguments = [
    "${pkgs.navidrome}/bin/navidrome"
    "--configfile"
    "${navidromeConfigurationFile}"
  ];

  launchd.user.agents.navidrome.serviceConfig.RunAtLoad = true;
  launchd.user.agents.navidrome.serviceConfig.KeepAlive = true;
  launchd.user.agents.navidrome.serviceConfig.WorkingDirectory = homeDirectory;
  launchd.user.agents.navidrome.serviceConfig.StandardOutPath = navidromeDaemonStandardFile;
  launchd.user.agents.navidrome.serviceConfig.StandardErrorPath = navidromeDaemonStandardFile;

  # Enable System Settings > Network > Firewall.
  networking.applicationFirewall.enable = true;

  # Allow built-in software to receive incoming connections.
  networking.applicationFirewall.allowSigned = true;

  # Allow downloaded signed software to receive incoming connections.
  networking.applicationFirewall.allowSignedApp = true;

  # Automatically run the nix store garbage collector (releasing).
  nix.gc.automatic = true;

  # Automatically run the nix store optimizer (compacting).
  nix.optimise.automatic = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Enable showing keystrokes when using sudo.
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Enable using Touch ID for sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # Enable Homebrew integration.
  homebrew.enable = true;
  homebrew.brews = [
    {
      name = "macos-trash";
    }
  ];

  homebrew.casks = [
    {
      # For some reason, calibre from Nixpkgs is unsupported on Darwin:
      # 
      #   Refusing to evaluate package 'qtwayland-6.11.0' in [...] because it is not available on the requested hostPlatform
      name = "calibre";
    }
    {
      name = "mac-mouse-fix";
    }
  ];
}

{ pkgs, inputs, ... }: let
  organizationID = "com.kyleerhabor";
  homeDirectory = "/Users/kyleerhabor";
  configurationDirectory = "${homeDirectory}/.config/nix-darwin";
  activationScriptFile = "${configurationDirectory}/modules/configuration/resources/activate.sh";

  # Paths
  nginxConfigurationFile = "${configurationDirectory}/modules/configuration/resources/nginx/nginx.conf";
  nginxConfigurationDestinationTargetFile = "nginx/nginx.conf";
  nginxConfigurationDestinationFile = "/etc/${nginxConfigurationDestinationTargetFile}";
  nginxConfigurationMimeTypesDestinationTargetFile = "nginx/mime.types";
  nginxConfigurationSCGIParametersDestinationTargetFile = "nginx/scgi_params";
  nginxConfigurationFastCGIParametersDestinationTargetFile = "nginx/fastcgi_params";
  nginxConfigurationRuTorrentDestinationTargetDirectory = "nginx/rutorrent";
  nginxLogDirectory = "/var/log/nginx";
  rtorrentLogDirectory = "/var/log/rtorrent";
  rtorrentPrivateLogDirectory = "/var/log/rtorrent-private";
  rtorrentConfigurationMainDestinationTargetFile = "rtorrent/main.rc";
  rtorrentConfigurationMainDestinationFile = "/etc/${rtorrentConfigurationMainDestinationTargetFile}";
  rtorrentConfigurationRtorrentTemplateDestinationTargetFile = "rtorrent/configurations/rtorrent/template.rc";
  rtorrentConfigurationRtorrentTemplateDestinationFile = "/etc/${rtorrentConfigurationRtorrentTemplateDestinationTargetFile}";
  rtorrentConfigurationRtorrentMainDestinationTargetFile = "rtorrent/configurations/rtorrent/main.rc";
  rtorrentConfigurationRtorrentMainDestinationFile = "/etc/${rtorrentConfigurationRtorrentMainDestinationTargetFile}";
  rtorrentConfigurationRtorrentPrivateTemplateDestinationTargetFile = "rtorrent/configurations/rtorrent-private/template.rc";
  rtorrentConfigurationRtorrentPrivateTemplateDestinationFile = "/etc/${rtorrentConfigurationRtorrentPrivateTemplateDestinationTargetFile}";
  rtorrentConfigurationRtorrentPrivateMainDestinationTargetFile = "rtorrent/configurations/rtorrent-private/main.rc";
  rtorrentConfigurationRtorrentPrivateMainDestinationFile = "/etc/${rtorrentConfigurationRtorrentPrivateMainDestinationTargetFile}";
  phpFPMLogDirectory = "/var/log/php-fpm";
  phpFPMConfigurationFile = "${configurationDirectory}/modules/configuration/resources/php-fpm/php-fpm.conf";
  phpFPMConfigurationDestinationTargetFile = "php-fpm/php-fpm.conf";
  phpFPMConfigurationDestinationFile = "/etc/${phpFPMConfigurationDestinationTargetFile}";

  # Groups
  nginxGroupName = "nginx";
  nginxGroupID = 600;

  # Users
  nginxUserName = "nginx";
  nginxUserID = 600;
  nginxUserHomeDirectory = "/var/empty";
  rtorrentUserName = "rtorrent";
  rtorrentUserID = 601;
  rtorrentUserHomeDirectory = "/var/rtorrent";
  phpFPMUserName = "phpfpm";
  phpFPMUserID = 602;
  phpFPMUserHomeDirectory = "/var/empty";

  # Daemons
  nginxDaemonID = "${organizationID}.nginx";
  nginxDaemonStandardOutputFile = "${nginxLogDirectory}/access.log";
  nginxDaemonStandardErrorFile = "${nginxLogDirectory}/error.log";
  rtorrentDaemonID = "${organizationID}.rtorrent";
  rtorrentDaemonStandardOutputFile = "${rtorrentLogDirectory}/access.log";
  rtorrentDaemonStandardErrorFile = "${rtorrentLogDirectory}/error.log";
  rtorrentPrivateDaemonID = "${organizationID}.rtorrent-private";
  rtorrentPrivateDaemonStandardOutputFile = "${rtorrentPrivateLogDirectory}/access.log";
  rtorrentPrivateDaemonStandardErrorFile = "${rtorrentPrivateLogDirectory}/error.log";
  phpFPMDaemonID = "${organizationID}.php-fpm";
  phpFPMDaemonStandardOutputFilePath = "${phpFPMLogDirectory}/access.log";
  phpFPMDaemonStandardErrorFilePath = "${phpFPMLogDirectory}/error.log";
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
    # nginx
    nixd
    # nodejs_24
    nushell
    # php
    pyenv
    # rtorrent
    rustup
    # rutorrent
    smartmontools
    sqlitebrowser
    # subversion # Used to clone XLD once.
    tree
    # unrar
    vscode
    # xmlrpc_c
  ];

  # environment.etc.nginx.source = nginxConfigurationFile;
  # environment.etc.nginx.target = nginxConfigurationDestinationTargetFile;
  # environment.etc.nginx-mime-types.source = "${pkgs.nginx}/conf/mime.types";
  # environment.etc.nginx-mime-types.target = nginxConfigurationMimeTypesDestinationTargetFile;
  # environment.etc.nginx-scgi-params.source = "${pkgs.nginx}/conf/scgi_params";
  # environment.etc.nginx-scgi-params.target = nginxConfigurationSCGIParametersDestinationTargetFile;
  # environment.etc.nginx-fastcgi-parameters.source = "${pkgs.nginx}/conf/fastcgi_params";
  # environment.etc.nginx-fastcgi-parameters.target = nginxConfigurationFastCGIParametersDestinationTargetFile;
  # environment.etc.nginx-rutorrent.source = "${pkgs.rutorrent}";
  # environment.etc.nginx-rutorrent.target = nginxConfigurationRuTorrentDestinationTargetDirectory;
  # # We can't use source since rtorrent doesn't run as root and therefore can't read our parent directories.
  # environment.etc.rtorrent-main.text = builtins.readFile ./configuration/resources/rtorrent/main.rc;
  # environment.etc.rtorrent-main.target = rtorrentConfigurationMainDestinationTargetFile;
  # environment.etc.rtorrent-configuration-template.text = builtins.readFile ./configuration/resources/rtorrent/configurations/rtorrent/template.rc;
  # environment.etc.rtorrent-configuration-template.target = rtorrentConfigurationRtorrentTemplateDestinationTargetFile;
  # environment.etc.rtorrent-configuration-main.text = builtins.readFile ./configuration/resources/rtorrent/configurations/rtorrent/main.rc;
  # environment.etc.rtorrent-configuration-main.target = rtorrentConfigurationRtorrentMainDestinationTargetFile;
  # environment.etc.rtorrent-private-configuration-template.text = builtins.readFile ./configuration/resources/rtorrent/configurations/rtorrent-private/template.rc;
  # environment.etc.rtorrent-private-configuration-template.target = rtorrentConfigurationRtorrentPrivateTemplateDestinationTargetFile;
  # environment.etc.rtorrent-private-configuration-main.text = builtins.readFile ./configuration/resources/rtorrent/configurations/rtorrent-private/main.rc;
  # environment.etc.rtorrent-private-configuration-main.target = rtorrentConfigurationRtorrentPrivateMainDestinationTargetFile;
  # environment.etc.php-fpm.source = phpFPMConfigurationFile;
  # environment.etc.php-fpm.target = phpFPMConfigurationDestinationTargetFile;
  #
  # launchd.daemons.nginx.serviceConfig.Label = nginxDaemonID;
  # launchd.daemons.nginx.serviceConfig.ProgramArguments = [
  #   "${pkgs.nginx}/bin/nginx"
  #   "-c" nginxConfigurationDestinationFile
  # ];
  #
  # launchd.daemons.nginx.serviceConfig.KeepAlive = true;
  # launchd.daemons.nginx.serviceConfig.RunAtLoad = true;
  # launchd.daemons.nginx.serviceConfig.StandardOutPath = nginxDaemonStandardOutputFile;
  # launchd.daemons.nginx.serviceConfig.StandardErrorPath = nginxDaemonStandardErrorFile;
  # launchd.daemons.rtorrent.path = [
  #   "${pkgs.ffmpeg-full}/bin"
  #   "${pkgs.mediainfo}/bin"
  #   "${pkgs.php}/bin"
  #   "${pkgs.unrar}/bin"
  #   "/usr/bin"
  #   "/bin"
  # ];
  #
  # launchd.daemons.rtorrent.serviceConfig.Label = rtorrentDaemonID;
  # launchd.daemons.rtorrent.serviceConfig.ProgramArguments = [
  #   "${pkgs.rtorrent}/bin/rtorrent"
  #   "-n"
  #   "-o" "import=${rtorrentConfigurationRtorrentTemplateDestinationFile}"
  #   "-o" "import=${rtorrentConfigurationRtorrentMainDestinationFile}"
  #   "-o" "import=${rtorrentConfigurationMainDestinationFile}"
  # ];
  #
  # launchd.daemons.rtorrent.serviceConfig.UserName = rtorrentUserName;
  # launchd.daemons.rtorrent.serviceConfig.KeepAlive = true;
  # launchd.daemons.rtorrent.serviceConfig.RunAtLoad = true;
  # launchd.daemons.rtorrent.serviceConfig.StandardOutPath = rtorrentDaemonStandardOutputFile;
  # launchd.daemons.rtorrent.serviceConfig.StandardErrorPath = rtorrentDaemonStandardErrorFile;
  # launchd.daemons.rtorrent-private.path = [
  #   "${pkgs.ffmpeg-full}/bin"
  #   "${pkgs.mediainfo}/bin"
  #   "${pkgs.php}/bin"
  #   "${pkgs.unrar}/bin"
  #   "/usr/bin"
  #   "/bin"
  # ];
  #
  # launchd.daemons.rtorrent-private.serviceConfig.Label = rtorrentPrivateDaemonID;
  # launchd.daemons.rtorrent-private.serviceConfig.ProgramArguments = [
  #   "${pkgs.rtorrent}/bin/rtorrent"
  #   "-n"
  #   "-o" "import=${rtorrentConfigurationRtorrentPrivateTemplateDestinationFile}"
  #   "-o" "import=${rtorrentConfigurationRtorrentPrivateMainDestinationFile}"
  #   "-o" "import=${rtorrentConfigurationMainDestinationFile}"
  # ];
  #
  # launchd.daemons.rtorrent-private.serviceConfig.UserName = rtorrentUserName;
  # launchd.daemons.rtorrent-private.serviceConfig.KeepAlive = true;
  # launchd.daemons.rtorrent-private.serviceConfig.RunAtLoad = true;
  # launchd.daemons.rtorrent-private.serviceConfig.StandardOutPath = rtorrentPrivateDaemonStandardOutputFile;
  # launchd.daemons.rtorrent-private.serviceConfig.StandardErrorPath = rtorrentPrivateDaemonStandardErrorFile;
  # launchd.daemons.php-fpm.serviceConfig.Label = phpFPMDaemonID;
  # launchd.daemons.php-fpm.serviceConfig.ProgramArguments = [
  #   "${pkgs.php}/bin/php-fpm"
  #   "--nodaemonize"
  #   "--fpm-config" phpFPMConfigurationDestinationFile
  # ];
  #
  # launchd.daemons.php-fpm.serviceConfig.KeepAlive = true;
  # launchd.daemons.php-fpm.serviceConfig.RunAtLoad = true;
  # launchd.daemons.php-fpm.serviceConfig.StandardOutPath = phpFPMDaemonStandardOutputFilePath;
  # launchd.daemons.php-fpm.serviceConfig.StandardErrorPath = phpFPMDaemonStandardErrorFilePath;
  #
  # system.activationScripts.activate.source = activationScriptFile;
  #
  # users.users.nginx.name = nginxUserName;
  # users.users.nginx.uid = nginxUserID;
  # users.users.nginx.gid = nginxGroupID;
  # users.users.nginx.home = nginxUserHomeDirectory;
  # users.groups.nginx.name = nginxGroupName;
  # users.groups.nginx.gid = nginxGroupID;
  # users.users.rtorrent.name = rtorrentUserName;
  # users.users.rtorrent.uid = rtorrentUserID;
  # users.users.rtorrent.gid = nginxGroupID;
  # users.users.rtorrent.home = rtorrentUserHomeDirectory;
  # users.users.php-fpm.name = phpFPMUserName;
  # users.users.php-fpm.uid = phpFPMUserID;
  # users.users.php-fpm.gid = nginxGroupID;
  # users.users.php-fpm.home = phpFPMUserHomeDirectory;
  # users.knownGroups = [nginxGroupName];
  # users.knownUsers = [
  #   nginxUserName
  #   rtorrentUserName
  #   phpFPMUserName
  # ];

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

{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ffmpeg-full mpv nushell sqlitebrowser];

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

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

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
      name = "calibre";
    }
  ];
}

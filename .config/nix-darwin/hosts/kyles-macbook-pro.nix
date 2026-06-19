{ ... }: {
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowDeprecatedx86_64Darwin = true;

  # Homebrew.
  system.primaryUser = "kyleerhabor";

  users.users.kyleerhabor.name = "kyleerhabor";
  users.users.kyleerhabor.home = "/Users/kyleerhabor";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.kyleerhabor = { ... }: {
    # Backwards compatibility for Home Manager.
    home.stateVersion = "25.11";
    imports = [../home/kyleerhabor.nix];
  };
}

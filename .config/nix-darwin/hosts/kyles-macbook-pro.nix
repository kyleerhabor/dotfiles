{ ... }: {
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Homebrew.
  system.primaryUser = "kyleerhabor";

  users.users.kyleerhabor.name = "kyleerhabor";
  users.users.kyleerhabor.home = "/Users/kyleerhabor";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.kyleerhabor = { ... }: {
    # Backwards compatibility for Home Manager.
    home.stateVersion = "26.05";
    imports = [../home/kyleerhabor.nix];
  };
}

{ pkgs, ... }: let
  gitignoreFile = pkgs.writeText "global-gitignore" (builtins.readFile ./kyleerhabor/resources/git/ignore);
in {
  # Enable Git integration.
  programs.git.enable = true;

  # Configuration written to $XDG_CONFIG_HOME/git/config. See git-config(1) for details.
  programs.git.settings.user.name = "Kyle Erhabor";
  programs.git.settings.user.email = "kyleerhabor@gmail.com";
  programs.git.settings.core.excludesFile = "${gitignoreFile}";

  # Enable Nushell integration.
  programs.nushell.enable = true;
}

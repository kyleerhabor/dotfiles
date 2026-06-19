{ pkgs, ... }: let
  home = "/Users/kyleerhabor";
  navidrome = "com.kyleerhabor.navidrome";
in {
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowDeprecatedx86_64Darwin = true;

  # Navidrome
  #
  # I don't recall why this is Intel. I think I may have used /usr/local/bin before pkgs.navidrome. This should either
  # be in configuration once the home variable is extracted, or in hosts for per-machine configuration.
  launchd.user.agents.navidrome.serviceConfig.Label = navidrome;
  launchd.user.agents.navidrome.serviceConfig.ProgramArguments = [
    "${pkgs.navidrome}/bin/navidrome"
    "--configfile"
    "${home}/.config/nix-darwin/modules/intel/navidrome.toml"
  ];

  launchd.user.agents.navidrome.serviceConfig.RunAtLoad = true;
  launchd.user.agents.navidrome.serviceConfig.KeepAlive = true;
  launchd.user.agents.navidrome.serviceConfig.WorkingDirectory = home;
  launchd.user.agents.navidrome.serviceConfig.StandardOutPath = "${home}/Library/Logs/${navidrome}.log";
  launchd.user.agents.navidrome.serviceConfig.StandardErrorPath = "${home}/Library/Logs/${navidrome}.log";
}

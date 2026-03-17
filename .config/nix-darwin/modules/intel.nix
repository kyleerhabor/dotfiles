{ ... }: {
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowDeprecatedx86_64Darwin = true;
}

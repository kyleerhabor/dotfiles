{
  description = "nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    # nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    # home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ nix-darwin, home-manager, ... }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Kyles-MacBook-Pro
    darwinConfigurations."Kyles-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/configuration.nix
        home-manager.darwinModules.home-manager
        ./hosts/kyles-macbook-pro.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}

{
  description = "nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ nix-darwin, home-manager, ... }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Kyles-MacBook-Pro
    darwinConfigurations."Kyles-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/configuration.nix
        ./modules/intel.nix
        home-manager.darwinModules.home-manager
        ./hosts/kyles-macbook-pro.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}

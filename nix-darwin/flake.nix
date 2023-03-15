{
  description = "hnbnh's macos workspace";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {
    darwinConfigurations.hnbnh = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
      ];
      inputs = { inherit nixpkgs darwin home-manager; };
    };
  };
}

{
  description = "hnbnh's workspace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, system-manager, nix-system-graphics }: {
    darwinConfigurations.hnbnh = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/hnbnh/darwin.nix
        home-manager.darwinModules.home-manager
      ];
      inputs = { inherit nixpkgs darwin home-manager; };
    };

    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [
        nix-system-graphics.systemModules.default
        ./hosts/hnbnh/system.nix
      ];
    };

    packages.aarch64-darwin.darwin-rebuild = darwin.packages.aarch64-darwin.darwin-rebuild;
    packages.aarch64-linux.system-manager = system-manager.packages.aarch64-linux.default;
    packages.aarch64-linux.home-manager = home-manager.packages.aarch64-linux.home-manager;

    homeConfigurations.hnbnh = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      modules = [ ./hosts/hnbnh/home-linux.nix ];
    };
  };
}

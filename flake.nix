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
  };

  outputs = { self, nixpkgs, darwin, home-manager, system-manager }: {
    darwinConfigurations.hnbnh = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/hnbnh
        home-manager.darwinModules.home-manager
      ];
      inputs = { inherit nixpkgs darwin home-manager; };
    };

    # Linux (Fedora) is split in two, the way nix-darwin + home-manager is on
    # macOS: system-manager owns /etc and system units, standalone
    # home-manager owns the user (packages, dotfiles, desktop).
    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [ ./modules/system ];
    };

    homeConfigurations.hnbnh = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      modules = [ ./modules/linux.nix ];
    };
  };
}

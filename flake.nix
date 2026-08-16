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
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {
    darwinConfigurations.hnbnh = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/hnbnh
        home-manager.darwinModules.home-manager
      ];
      inputs = { inherit nixpkgs darwin home-manager; };
    };

    # Standalone home-manager for Linux: same dotfiles and CLI tools as macOS,
    # plus the Hyprland desktop bits. System packages come from ansible.
    homeConfigurations.hnbnh = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      modules = [
        ./modules/user.nix
        ./modules/packages/linux.nix
        {
          home.username = "hnbnh";
          home.homeDirectory = "/home/hnbnh";
        }
      ];
    };
  };
}

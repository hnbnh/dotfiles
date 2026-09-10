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

  outputs = { self, nixpkgs, darwin, home-manager, system-manager, nix-system-graphics }:
    let
      inherit (nixpkgs) lib;

      # Impure by design: a fresh machine should need no repo edit. macOS
      # switches under sudo (install/macos.sh), so SUDO_USER is the real
      # account, not USER. In pure evaluation every getEnv returns "", so CI
      # falls back to hnbnh.
      username =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          user = builtins.getEnv "USER";
        in
        if sudoUser != "" then
          sudoUser
        else if user != "" then
          user
        else
          "hnbnh";

      specialArgs = system: {
        platform = lib.systems.elaborate system;
        inherit username;
      };
    in
    {
      darwinConfigurations.hnbnh = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = specialArgs "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./base/darwin.nix
          ./hosts/hnbnh/darwin.nix
          { home-manager.users.${username}.imports = [ ./base/home.nix ]; }
        ];
      };

      systemConfigs.default = system-manager.lib.makeSystemConfig {
        specialArgs = specialArgs "aarch64-linux";
        modules = [
          nix-system-graphics.systemModules.default
          ./base/system.nix
          ./hosts/hnbnh/system.nix
        ];
      };

      packages.aarch64-darwin.darwin-rebuild = darwin.packages.aarch64-darwin.darwin-rebuild;
      packages.aarch64-linux.system-manager = system-manager.packages.aarch64-linux.default;
      packages.aarch64-linux.home-manager = home-manager.packages.aarch64-linux.home-manager;

      homeConfigurations.hnbnh = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = specialArgs "aarch64-linux";
        # Order is load-bearing — see the note in Task 3's homeModules.
        modules = [
          ./hosts/hnbnh/home-linux.nix
          ./base/home.nix
        ];
      };
    };
}

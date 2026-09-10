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

  outputs = { nixpkgs, darwin, home-manager, system-manager, nix-system-graphics, ... }:
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

      hosts = {
        mac = { system = "aarch64-darwin"; };
        fedora = { system = "aarch64-linux"; };
      };

      platformOf = host: lib.systems.elaborate host.system;
      hostsWhere = pred: lib.filterAttrs (_: host: pred (platformOf host)) hosts;

      specialArgs = host: {
        platform = platformOf host;
        inherit username;
      };

      # Shared by the embedded (Darwin) and standalone (Fedora) home-manager
      # paths so the module list is decided in exactly one place.
      #
      # Order is load-bearing, and the host module deliberately comes first.
      # home.packages is a list, so module order fixes its concatenation order,
      # which in turn fixes fontconfig's font-directory precedence in
      # 10-hm-fonts.conf and buildEnv's file-collision resolution. Before the
      # refactor base/home.nix's content was nested inside the host module's
      # own imports; listing base first instead reorders home.packages and
      # changes the activation derivation. Verified against the pre-refactor
      # drvPath: this order reproduces it byte for byte, the reverse does not.
      homeModules = name: [
        ./hosts/${name}/home.nix
        ./base/home.nix
      ];

      mkDarwin = name: host: darwin.lib.darwinSystem {
        inherit (host) system;
        specialArgs = specialArgs host;
        modules = [
          home-manager.darwinModules.home-manager
          ./base/darwin.nix
          ./hosts/${name}/darwin.nix
          { home-manager.users.${username}.imports = homeModules name; }
        ];
      };

      mkHome = name: host: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${host.system};
        extraSpecialArgs = specialArgs host;
        modules = homeModules name;
      };

      mkSystem = name: host: system-manager.lib.makeSystemConfig {
        specialArgs = specialArgs host;
        modules = [
          nix-system-graphics.systemModules.default
          ./base/system.nix
          ./hosts/${name}/system.nix
        ];
      };
    in
    {
      darwinConfigurations = lib.mapAttrs mkDarwin (hostsWhere (p: p.isDarwin));
      systemConfigs = lib.mapAttrs mkSystem (hostsWhere (p: p.isLinux));
      homeConfigurations = lib.mapAttrs mkHome (hostsWhere (p: p.isLinux));

      packages.aarch64-darwin.darwin-rebuild = darwin.packages.aarch64-darwin.darwin-rebuild;
      packages.aarch64-linux.system-manager = system-manager.packages.aarch64-linux.default;
      packages.aarch64-linux.home-manager = home-manager.packages.aarch64-linux.home-manager;
    };
}

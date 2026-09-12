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

      packagesFor =
        system:
        if (lib.systems.elaborate system).isDarwin then
          { darwin-rebuild = darwin.packages.${system}.darwin-rebuild; }
        else
          {
            system-manager = system-manager.packages.${system}.default;
            home-manager = home-manager.packages.${system}.home-manager;
          };

      hostModules =
        name:
        let
          file = ./hosts/${name}.nix;
        in
        lib.mapAttrs (_: lib.setDefaultModuleLocation file) (import file);

      homeModules = name: [
        (hostModules name).home
        ./base
      ];

      mkDarwin = name: host: darwin.lib.darwinSystem {
        inherit (host) system;
        specialArgs = specialArgs host;
        modules = [
          home-manager.darwinModules.home-manager
          ./base/darwin.nix
          (hostModules name).system
          {
            home-manager.extraSpecialArgs = specialArgs host;
            home-manager.users.${username}.imports = homeModules name;
          }
        ];
      };

      mkHome = name: host: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${host.system};
        extraSpecialArgs = specialArgs host;
        modules = homeModules name;
      };

      mkSystem = name: host: system-manager.lib.makeSystemConfig {
        specialArgs = { platform = platformOf host; };
        modules = [
          nix-system-graphics.systemModules.default
          ./base/linux.nix
          (hostModules name).system
        ];
      };
    in
    {
      darwinConfigurations = lib.mapAttrs mkDarwin (hostsWhere (p: p.isDarwin));
      systemConfigs = lib.mapAttrs mkSystem (hostsWhere (p: p.isLinux));
      homeConfigurations = lib.mapAttrs mkHome (hostsWhere (p: p.isLinux));

      packages = lib.genAttrs (lib.unique (lib.mapAttrsToList (_: host: host.system) hosts)) packagesFor;
    };
}

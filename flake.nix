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

      # Bootstrap tools are per-system, so they follow the registry: a host on
      # a new architecture would otherwise build fine but have nothing to
      # switch it with.
      packagesFor =
        system:
        if (lib.systems.elaborate system).isDarwin then
          { darwin-rebuild = darwin.packages.${system}.darwin-rebuild; }
        else
          {
            system-manager = system-manager.packages.${system}.default;
            home-manager = home-manager.packages.${system}.home-manager;
          };

      # A host file holds one module per class, `system` and `home`. Taken out
      # of the file as plain values, their definitions would show up in
      # evaluation errors as <unknown-file>, so each gets the path attached.
      # Not via lib.setDefaultModuleLocation: its wrapper adds an import level,
      # imports are collected breadth-first, and the extra level reorders
      # home.packages (see homeModules below).
      hostModules =
        name:
        let
          file = ./hosts/${name}.nix;
          locate =
            m:
            if lib.isFunction m then
              lib.mirrorFunctionArgs m (args: m args // { _file = file; })
            else
              m // { _file = file; };
        in
        lib.mapAttrs (_: locate) (import file);

      # Shared by the embedded (Darwin) and standalone (Fedora) home-manager
      # paths so the module list is decided in exactly one place.
      #
      # home.packages is a list, so module order fixes its concatenation order
      # and with it the home-manager-path derivation. Nothing functional
      # depends on it: 10-hm-fonts.conf lists profile directories rather than
      # packages, and home-manager's buildEnv rejects colliding files instead
      # of letting one win by position.
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
            # Both home-manager paths draw their arguments from one expression;
            # mkHome does the same. Re-declaring these separately is how the two
            # platforms drift apart.
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
        # Deliberately not `specialArgs host`: the system class is evaluated
        # without --impure, so `username` here would silently be the pure-eval
        # fallback on every machine. Omitting it makes a future reference fail
        # loudly instead.
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

{
  description = "hnbnh's workspace";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
    }:
    {
      darwinConfigurations.hnbnh = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
        ];
        inputs = { inherit nixpkgs darwin; };
      };

      packages.aarch64-linux =
        let
          pkgs = import nixpkgs { system = "aarch64-linux"; };
          sharedPackages = import ./packages.nix { pkgs = pkgs; };
        in
        {
          default = pkgs.buildEnv {
            name = "packages";
            paths = sharedPackages;
          };
        };
    };
}

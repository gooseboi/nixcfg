{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = inputs @ {
    disko,
    fenix,
    flake-utils,
    home-manager,
    nixos-hardware,
    nixpkgs,
    ...
  }: let
    mkHost = hostName: system: extraModules: let
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };

        modules =
          [
            ./hosts/${hostName}/configuration.nix

            ./modules
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
            }

            ({...}: {
              nixpkgs.overlays = [fenix.overlays.default];
            })

            ({...}: {
              networking.hostName = hostName;

              nixpkgs.hostPlatform = system;

              nix = {
                settings.experimental-features = ["nix-command" "flakes"];
                registry.nixpkgs.to = {
                  owner = "NixOS";
                  repo = "nixpkgs";
                  rev = inputs.nixpkgs.rev;
                  type = "github";
                };
              };
            })
          ]
          ++ extraModules;
      };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      formatter = pkgs.alejandra;
    })
    // {
      nixosConfigurations = {
        filth = mkHost "filth" "aarch64-linux" [
          nixos-hardware.nixosModules.raspberry-pi-4
        ];

        anatidae = mkHost "anatidae" "x86_64-linux" [];
      };
    };
}

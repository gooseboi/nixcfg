{
  description = "Nixos config flake";

  nixConfig = {
    experimental-features = [
      "cgroups"
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    accept-flake-config = true;
    trusted-users = ["root" "@build" "@wheel" "@admin"];
    warn-dirty = false;
    use-cgroups = true;
    use-xdg-base-directories = true;
  };

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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs @ {
    agenix,
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
            # System config
            ./hosts/${hostName}/configuration.nix

            # Load system modules
            ./modules

            # Disko
            disko.nixosModules.disko

            # Secrets
            agenix.nixosModules.default

            # Home manager configs
            ({
              config,
              lib,
              ...
            }: {
              imports = [
                home-manager.nixosModules.home-manager
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                sharedModules = [./home];

                extraSpecialArgs = {
                  inherit inputs;
                  systemConfig = config;
                  mkMyLib = hmConfig: rec {
                    stringToPath = prefix: pathStr: prefix + builtins.toPath pathStr;
                    absoluteStringToPath = pathStr: stringToPath /. pathStr;
                    removeHomeDirPrefix = path: lib.path.removePrefix (absoluteStringToPath hmConfig.home.homeDirectory) path;
                    removeHomeDirPrefixStr = path: removeHomeDirPrefix (absoluteStringToPath path);
                  };
                };
              };
            })

            # Overlays
            ({lib, ...}: {
              nixpkgs.overlays = [
                fenix.overlays.default
                agenix.overlays.default
              ];

              nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["corefonts" "vista-fonts" "discord"];
            })

            # Nix/General configs
            ({...}: {
              networking.hostName = hostName;

              nixpkgs.hostPlatform = system;

              nix = {
                settings = (import ./flake.nix).nixConfig;
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
        anatidae = mkHost "anatidae" "x86_64-linux" [
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          {
            hardware.intelgpu.enableHybridCodec = true;
          }
        ];

        swordsmachine = mkHost "swordsmachine" "x86_64-linux" [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
      };
    };
}

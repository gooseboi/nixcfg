{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # This is not used directly, but rather to dedup inputs for other flakes (agenix and flake-utils)
    systems.url = "github:nix-systems/default";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

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
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
  };

  outputs = inputs @ {
    self,
    deploy-rs,
    flake-utils,
    nixos-hardware,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      deploy-rs-system = deploy-rs.packages.${system};
    in {
      formatter = pkgs.alejandra;
      apps = {
        deploy = {
          type = "app";
          program = "${deploy-rs-system.deploy-rs}/bin/deploy";
        };
      };
    })
    // (
      let
        lib = nixpkgs.lib.extend (import ./lib inputs);

        inherit (lib) mkHost;
      in {
        nixosConfigurations = {
          anatidae = mkHost "anatidae" "x86_64-linux" (with nixos-hardware.nixosModules; [
            common-cpu-intel
            common-gpu-intel
            common-pc-laptop-ssd
            {
              hardware.intelgpu.enableHybridCodec = true;
            }
          ]);

          swordsmachine = mkHost "swordsmachine" "x86_64-linux" (with nixos-hardware.nixosModules; [
            common-cpu-amd
            common-cpu-amd-pstate
            common-cpu-amd-zenpower
            common-gpu-amd
            common-pc-laptop-ssd
          ]);

          printer = mkHost "printer" "x86_64-linux" (with nixos-hardware.nixosModules; [
            common-cpu-intel
          ]);
        };

        deploy.nodes.printer = {
          hostname = "printer";
          profiles.system = {
            sshUser = "chonk";
            user = "chonk";
            interactiveSudo = true;
            path =
              deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.printer;
          };
        };
      }
    );
}

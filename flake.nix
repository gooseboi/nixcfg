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
    flake-utils,
    nixos-hardware,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      formatter = pkgs.alejandra;
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

          looker = mkHost "looker" "aarch64-linux" (with nixos-hardware.nixosModules; [
            raspberry-pi-4
          ]);
        };
      }
    );
}

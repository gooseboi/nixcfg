{
  description = "Nixos config flake";

  inputs = {
    # System packages and services
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home directory configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake organisation
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Rust packages
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative partition config
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Collection of configuration for hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remote deployments
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages
    tailray = {
      url = "github:notashelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };

      imports = [
        # All of the other stuff that's not system specific
        ./parts

        # The NixOS systems and their configs
        ./hosts
      ];
    };
}

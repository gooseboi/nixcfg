{
  inputs,
  self,
  lib,
  ...
}: let
  hw = inputs.nixos-hardware.nixosModules;
  deploy-rs = inputs.deploy-rs;

  inherit
    (self.lib)
    mapAttrs
    filterAttrs
    ;

  mkHost = hostName: system: extraModules:
    lib.nixosSystem {
      inherit system;
      specialArgs =
        # Adding `inputs`, while adding all flake inputs as arguments to every
        # module, also provides the `self` argument, the `outputs` set of the
        # flake. This is important because its `toPath` refers to the root of
        # the source code, and can therefore be used to import things relative
        # to the source root instead of the current file.
        inputs
        // {
          inherit inputs;
          lib = self.lib;
          keys = import (inputs.self + /keys.nix);
        };

      modules =
        [
          # System config
          ({self, ...}: {
            imports = [
              ./${hostName}/configuration.nix
              (self + /modules)
            ];
          })

          # Nix/General configs
          {
            networking.hostName = hostName;

            nixpkgs.hostPlatform = system;
          }
        ]
        ++ extraModules;
    };
in {
  flake = {
    nixosConfigurations = with hw; {
      indicus = mkHost "indicus" "x86_64-linux" [
        common-cpu-intel
        common-gpu-intel
        common-pc-laptop-ssd
        {
          hardware.intelgpu.enableHybridCodec = true;
        }
      ];

      canagicus = mkHost "canagicus" "x86_64-linux" [
        common-cpu-amd
        common-cpu-amd-pstate
        common-cpu-amd-zenpower
        common-gpu-amd
        common-pc-laptop-ssd
      ];

      printer = mkHost "printer" "x86_64-linux" [
        common-cpu-intel
      ];

      albifrons = mkHost "albifrons" "x86_64-linux" [];

      erythropus = mkHost "erythropus" "x86_64-linux" [];
    };

    deploy.nodes =
      self.nixosConfigurations
      |> filterAttrs (name: value: value.config.chonkos.deploy.enable)
      |> mapAttrs (name: value: let
        systemCfg = value.config;
        deployCfg = systemCfg.chonkos.deploy;
      in {
        # Tailscale
        hostname = name;
        profiles.system = {
          inherit
            (deployCfg)
            sshUser
            user
            interactiveSudo
            remoteBuild
            ;

          path =
            deploy-rs.lib.${systemCfg.nixpkgs.hostPlatform.system}.activate.nixos
            self.nixosConfigurations.${name};

          profilePath = "/nix/var/nix/profiles/system";
        };
      });
  };
}

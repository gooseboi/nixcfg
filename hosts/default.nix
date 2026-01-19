{
  inputs,
  self,
  ...
}: let
  hw = inputs.nixos-hardware.nixosModules;
  deploy-rs = inputs.deploy-rs;

  inherit (self.lib) mkHost;
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
    };

    # TODO: A nice way to auto-generate these?
    # TODO: No interactive sudo (a `deploy` user with /bin/nologin?)
    # TODO: Running deploy always checks every single nixos configuration, that's kinda stupid
    deploy.nodes = {
      canagicus = {
        hostname = "canagicus";
        profiles.system = {
          sshUser = "chonk";
          user = "chonk";
          interactiveSudo = true;
          remoteBuild = true;
          path =
            deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.canagicus;
        };
      };

      printer = {
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

      albifrons = {
        hostname = "albifrons";
        profiles.system = {
          sshUser = "chonk";
          user = "chonk";
          interactiveSudo = true;
          path =
            deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.albifrons;
        };
      };
    };
  };
}

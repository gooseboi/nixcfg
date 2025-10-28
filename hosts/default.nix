{
  inputs,
  lib,
  self,
  ...
}: let
  hw = inputs.nixos-hardware.nixosModules;
  deploy-rs = inputs.eploy-rs;

  # TODO: Extend lib in the flake and not here
  newLib = lib.extend (import ../lib inputs);

  inherit (newLib) mkHost;
in {
  flake = {
    nixosConfigurations = {
      anatidae = mkHost "anatidae" "x86_64-linux" (with hw; [
        common-cpu-intel
        common-gpu-intel
        common-pc-laptop-ssd
        {
          hardware.intelgpu.enableHybridCodec = true;
        }
      ]);

      swordsmachine = mkHost "swordsmachine" "x86_64-linux" (with hw; [
        common-cpu-amd
        common-cpu-amd-pstate
        common-cpu-amd-zenpower
        common-gpu-amd
        common-pc-laptop-ssd
      ]);

      printer = mkHost "printer" "x86_64-linux" (with hw; [
        common-cpu-intel
      ]);
    };

    # TODO: A nice way to auto-generate these?
    # TODO: No interactive sudo (a `deploy` user with /bin/nologin?)
    # TODO: Running deploy always checks every single nixos configuration, that's kinda stupid
    deploy.nodes = {
      swordsmachine = {
        hostname = "swordsmachine";
        profiles.system = {
          sshUser = "chonk";
          user = "chonk";
          interactiveSudo = true;
          remoteBuild = true;
          path =
            deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.swordsmachine;
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
    };
  };
}

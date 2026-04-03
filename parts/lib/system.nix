inputs: self: super: {
  mkHost = hostName: system: extraModules:
    super.nixosSystem {
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
          lib = self;
          keys = import (inputs.self + /keys.nix);
        };

      modules =
        [
          # System config
          ({self, ...}: {
            imports = [
              (self + /hosts/${hostName}/configuration.nix)
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
}

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
        };

      modules =
        [
          # System config
          ({self, ...}: {
            imports = [(self + /hosts/${hostName}/configuration.nix)];
          })

          # Load system modules
          ({self, ...}: {
            imports = [(self + /modules)];
          })

          # Disko
          inputs.disko.nixosModules.disko

          # Secrets
          inputs.agenix.nixosModules.default

          # Home manager configs
          ({
            config,
            lib,
            self,
            ...
          }: {
            imports = [
              inputs.home-manager.nixosModules.home-manager
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [(self + /home)];

              extraSpecialArgs = {
                inherit inputs;
                inherit (config.chonkos) isDesktop isServer;
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
              inputs.agenix.overlays.default
              inputs.fenix.overlays.default
            ];
          })

          # Nix/General configs
          ({self, ...}: {
            networking.hostName = hostName;

            nixpkgs.hostPlatform = system;

            nix = {
              settings = {
                experimental-features = [
                  "cgroups"
                  "flakes"
                  "nix-command"
                  "pipe-operators"
                ];

                trusted-users = ["root" "@build" "@wheel" "@admin"];
                warn-dirty = false;
                use-cgroups = true;
                use-xdg-base-directories = true;
              };

              registry.nixpkgs.flake = inputs.nixpkgs;
            };
          })
        ]
        ++ extraModules;
    };
}

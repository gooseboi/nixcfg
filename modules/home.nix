{
  config,
  inputs,
  lib,
  self,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      # Packages
      inputs.tailray.homeManagerModules.default

      (homeArgs: {
        options.chonkos.user = mkOption {
          type = types.str;
          example = "chonk";
          description = "the name of the user";
          readOnly = true;
        };

        config = let
          user = homeArgs.config.chonkos.user;
        in {
          home = {
            username = user;
            homeDirectory = "/home/${user}";
          };

          # Let Home Manager install and manage itself.
          programs.home-manager.enable = true;
        };
      })
    ];

    extraSpecialArgs = {
      inherit inputs;
      inherit (config.chonkos) isDesktop isServer;
      systemConfig = config;
    };
  };
}

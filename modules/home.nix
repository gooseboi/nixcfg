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
  # TODO: https://github.com/snugnug/hjem-rum/
  # TODO: https://github.com/feel-co/hjem
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      # Packages
      inputs.tailray.homeManagerModules.default

      {
        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      }
    ];

    extraSpecialArgs = {
      inherit inputs;
      inherit (config.chonkos) isDesktop isServer;
      systemConfig = config;
    };
  };
}

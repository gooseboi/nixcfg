{
  config,
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      (self + /home)

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

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
    ];

    extraSpecialArgs = {
      inherit inputs;
      inherit (config.chonkos) isDesktop isServer;
      systemConfig = config;
    };
  };
}

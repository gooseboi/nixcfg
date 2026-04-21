{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    inputs.nvf.nixosModules.default
    inputs.flux.nixosModules.default
  ];

  nixpkgs.overlays = [
    # This is the overlay defined in the flake parts
    self.overlays.default
    inputs.agenix.overlays.default
    inputs.fenix.overlays.default
    inputs.flux.overlays.default
  ];
}

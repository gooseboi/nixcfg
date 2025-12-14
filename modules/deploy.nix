{
  config,
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;

  inherit (config.chonkos) isDesktop;
in {
  config = {
    environment.systemPackages = mkIf isDesktop [
      # TODO: Is there a nicer way to reference this?
      inputs.deploy-rs.packages.${config.nixpkgs.hostPlatform.system}.deploy-rs
    ];
  };
}

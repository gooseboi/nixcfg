{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkMerge
    ;

  inherit
    (config.chonkos)
    isDesktop
    isServer
    ;
in {
  services.journald.settings.Journal = {
    # /var/log (Services)
    SystemMaxUse = mkMerge [
      (mkIf isDesktop "100M")
      (mkIf isServer "1G")
    ];
    # /run/var/log (Boot)
    RuntimeMaxUse = mkMerge [
      (mkIf isDesktop "50M")
      (mkIf isServer "500M")
    ];
  };
}

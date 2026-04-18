{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    optionalString
    ;

  inherit
    (config.chonkos)
    isDesktop
    isServer
    ;
in {
  services.journald.extraConfig =
    optionalString isDesktop ''
      # /var/log (Services)
      SystemMaxUse=100M
      # /run/var/log (Boot)
      RuntimeMaxUse=50M
    ''
    + optionalString isServer ''
      # /var/log (Services)
      SystemMaxUse=1G
      # /run/var/log (Boot)
      RuntimeMaxUse=500M
    '';
}

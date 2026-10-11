{config, ...}: let
  inherit
    (config.chonkos)
    isServer
    ;
in {
  boot.tmp.cleanOnBoot = true;

  system.disableInstallerTools = isServer;
}

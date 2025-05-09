{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos;
in {
  options.chonkos.network-manager = {
    enable = lib.mkEnableOption "enable network manager";
  };

  config = lib.mkIf cfg.network-manager.enable {
    networking.networkmanager.enable = true;

    users.users.${cfg.user}.extraGroups = ["networkmanager"];

    # Blatantly stolen from https://github.com/RGBCube/NCC/blob/06cce18e7259e060a65af2af2bf0e609cd8e9a2c/modules/linux/network-manager.nix
    environment.shellAliases.wifi = "nmcli dev wifi show-password";
  };
}

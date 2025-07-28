{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.network-manager;
in {
  options.chonkos.network-manager = {
    enable = mkEnableOption "enable network manager";
  };

  config = mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;

      unmanaged = [
        "type:bridge"

        # Tailscale
        "interface-name:tailscale*"
        # Tailscale
        "interface-name:ts*"

        # Docker bridge
        "interface-name:docker0"
        # Docker container interfaces
        "interface-name:veth*"
        # Docker container interfaces
        "interface-name:br*"

        # QEMU
        "interface-name:virbr*"
      ];

      wifi = {
        # Random on every connection
        macAddress = "random";
        # Duh
        powersave = true;
        # Randomize MAC address when scanning
        scanRandMacAddress = true;
      };
    };

    users.users.${config.chonkos.user}.extraGroups = ["networkmanager"];

    systemd.network.wait-online.enable = false;

    # Blatantly stolen from https://github.com/RGBCube/NCC/blob/06cce18e7259e060a65af2af2bf0e609cd8e9a2c/modules/linux/network-manager.nix
    environment.shellAliases.wifi = "nmcli dev wifi show-password";
  };
}

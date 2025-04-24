{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.virt-manager;
in {
  options.chonkos.virt-manager = {
    enable = lib.mkEnableOption "enable virt-manager";
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [virtiofsd];
    };
    users.groups.libvirtd.members = [config.chonkos.user];

    virtualisation.spiceUSBRedirection.enable = true;

    home-manager = {
      sharedModules = [
        {
          dconf.settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = ["qemu:///system"];
              uris = ["qemu:///system"];
            };
          };
        }
      ];
    };
  };
}

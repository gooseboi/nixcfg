{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.virt-manager;
in {
  options.chonkos.virt-manager = {
    enable = mkEnableOption "enable virt-manager";
  };

  config = mkIf cfg.enable {
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

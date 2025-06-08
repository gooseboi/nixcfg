{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-QEMU_DVD-ROM_QM00005";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };

        swap = {
        };

        primary = {
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "rootvol";
          };
        };
      };
    };
  };
}

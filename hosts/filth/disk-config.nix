{...}: {
  disko.devices = {
    disk.disk1 = {
      device = "/dev/mmcblk0";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountoptions = ["defaults"];
            };
          };

          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}

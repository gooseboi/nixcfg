{pkgs, ...}: {
  chonkos.unfree.allowed = ["cups-brother-dcpt420w"];

  services = {
    printing = {
      enable = true;
      drivers = [pkgs.dcpt420w-driver];

      listenAddresses = ["*:631"];
      allowFrom = ["all"];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      logLevel = "debug";
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };

  hardware.printers = {
    # Bus 001 Device 003: ID 04f9:0475 Brother Industries, Ltd DCP-T420W
    ensurePrinters = [
      {
        name = "DCPT420W";
        location = "Cuarto de Guz";
        deviceUri = "usb://Brother/DCP-T420W?serial=U66052F4H760958";
        model = "brother_dcpt420w_printer_en.ppd";
        ppdOptions = {
          pageSize = "A4";
        };
      }
    ];
  };

  # The nixpkgs module for cups always adds samba, and this system doesn't need
  # it. Removing it removes like 70MiB from the closure.
  nixpkgs.overlays = [
    (_: prev: {
      samba = prev.writeShellScriptBin "smbspool" ''
        echo "smb printing is not available on this host" >&2
        exit 1
      '';
    })
  ];

  users.users.printer = {
    isSystemUser = true;
    group = "lpadmin";
    # It doesn't matter it's plaintext, since this user can't do anything,
    # and they can't interactively login.
    password = "printer";
    shell = pkgs.shadow;
  };
}

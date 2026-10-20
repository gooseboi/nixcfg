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

  # These are packages that are pulled in by the cups module in nixpkgs,
  # and that aren't needed on this server.
  nixpkgs.overlays = [
    (_: prev: {
      # This is used for printing through samba, and the printer is always on
      # USB.
      samba = prev.writeShellScriptBin "smbspool" ''
        echo "smb printing is not available on this host" >&2
        exit 1
      '';
      # This is pulled in because on desktops cups needs to be able to open up
      # some dialogue, and obviously this isn't a desktop.
      xdg-utils = prev.writeShellScriptBin "xdg-open" ''
        echo "there is no desktop on this host" >&2
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

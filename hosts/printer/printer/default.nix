{
  pkgs,
  lib,
  ...
}: let
  dcpt420w-driver = pkgs.callPackage ./dcpt420w-driver.nix {};
in {
  chonkos.unfree.allowed = ["cups-brother-dcpt420w"];

  services = {
    printing = {
      enable = true;
      drivers = [dcpt420w-driver];

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
}

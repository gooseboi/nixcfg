{
  pkgs,
  lib,
  ...
}: let
  dcpt420w-driver = pkgs.callPackage ./dcpt420w-driver.nix {};
in {
  chonkos.unfree.allowed = ["dcpt420w-lpr"];

  services = {
    printing = {
      enable = true;
      drivers = [dcpt420w-driver];

      listenAddresses = ["*:631"];
      allowFrom = ["all"];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
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
        deviceUri = "usb://Brother";
        model = "blah";
        ppdOptions = {
          pageSize = "A4";
        };
      }
    ];
  };
}

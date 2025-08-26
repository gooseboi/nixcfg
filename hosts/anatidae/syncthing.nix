{config, ...}: {
  services.syncthing = {
    enable = true;

    dataDir = "/home/${config.chonkos.user}";

    settings = {
      devices = {
        "anser" = {id = "3IBIEL6-6QNWOKJ-NZ5UJHB-QNC54FV-3I7EU7G-M5NPWDH-AWGHDCB-WFXV6AE";};
        "pixel7" = {id = "4TQ7FPC-3CE33Y6-Q27XXAY-URCGU7S-A7AUGT4-LX77I3Z-AS5RGZ6-MWWSRAU";};
        "cowboy" = {
          id = "RD7VJNX-HFZE4BB-E45QICM-TPSRK6P-CRU3VRM-ANT7GUZ-LJZ3N3S-UZFIHA3";
          addresses = ["tcp://gooseman.net"];
        };
      };

      folders = {
        "dox" = {
          enable = true;
          id = "4lkyi-u5rlc";
          path = "~/dox";
          devices = ["anser"];
        };
        "music" = {
          enable = true;
          id = "hygaw-rg6ui";
          path = "~/music";
          devices = ["anser" "pixel7"];
        };
        "pix" = {
          enable = true;
          id = "zdjfq-o6neh";
          path = "~/pix";
          devices = ["anser"];
        };
        "vids" = {
          enable = true;
          id = "kqsee-nrs9r";
          path = "~/vids";
          devices = ["anser"];
        };
        "wiki" = {
          enable = true;
          id = "tubeq-7p6cx";
          path = "~/wiki";
          devices = ["anser"];
        };
        "phone_share" = {
          enable = true;
          id = "qldge-3djeg";
          path = "~/phone_share";
          devices = ["anser" "pixel7"];
        };
      };
    };
  };
}

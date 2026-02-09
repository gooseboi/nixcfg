{config, ...}: {
  age.secrets.syncthing-key.file = ./syncthing-key.age;
  age.secrets.syncthing-cert.file = ./syncthing-cert.age;

  services.syncthing = {
    enable = true;

    cert = config.age.secrets.syncthing-cert.path;
    key = config.age.secrets.syncthing-key.path;

    dataDir = "/home/${config.chonkos.user}";
    configDir = "/home/${config.chonkos.user}/.config/syncthing";
    databaseDir = "/home/${config.chonkos.user}/.local/share/syncthing";

    settings = {
      devices = {
        "anser" = {id = "3IBIEL6-6QNWOKJ-NZ5UJHB-QNC54FV-3I7EU7G-M5NPWDH-AWGHDCB-WFXV6AE";};
        "pixel7" = {id = "4TQ7FPC-3CE33Y6-Q27XXAY-URCGU7S-A7AUGT4-LX77I3Z-AS5RGZ6-MWWSRAU";};
        "SM-A107M" = {id = "WGBHLXR-C7UZMPY-DY3SGCU-LJECWCW-SDQZ55L-RM6AT3U-I4AEZ6C-IGC7NQ4";};
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
          devices = ["anser" "pixel7" "SM-A107M"];
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

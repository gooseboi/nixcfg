{config, ...}: {
  systemd.services.syncthing = {
    environment.STNODEFAULTFOLDER = "true";

    # Hardening
    serviceConfig = {
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  services.syncthing = {
    enable = true;

    user = config.chonkos.user;
    dataDir = "/home/${config.chonkos.user}";
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      gui = {
        theme = "dark";
      };

      devices = {
        "anser" = {id = "3IBIEL6-6QNWOKJ-NZ5UJHB-QNC54FV-3I7EU7G-M5NPWDH-AWGHDCB-WFXV6AE";};
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
          devices = ["anser"];
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
      };

      options.urAccepted = -1; # Disable telemetry.
    };
  };
}

{config, ...}: {
  # TODO: Impermanence (https://notthebe.ee/blog/nixos-ephemeral-zfs-root/)

  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    binfmt = {
      emulatedSystems = ["aarch64-linux" "riscv64-linux"];
    };
  };

  programs.nix-ld.enable = true;

  time.timeZone = "America/Montevideo";

  i18n = rec {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_US/ISO-8859-1"

      "es_UY.UTF-8/UTF-8"
      "es_UY/ISO-8859-1"

      "ja_JP.EUC-JP/EUC-JP"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["wheel" "video" "audio" "dialout"];
    hashedPasswordFile = config.age.secrets.chonk-hashedPassword.path;
  };

  home-manager.users.chonk = import ./home.nix;

  programs.firefox.enable = true;

  chonkos = {
    user = "chonk";
    agenix.enable = true;
    desktop.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
    network-manager.enable = true;
    tlp.enable = true;
    docker.enable = true;
    virt-manager.enable = true;
    hyprland.enable = true;
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  services.syncthing = {
    enable = true;

    user = config.chonkos.user;
    dataDir = "/home/${config.chonkos.user}";
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "anser" = {id = "3IBIEL6-GQNWOKJ-NZ5UJHB-QNC54FV-3I7EU7G-M5NPWDH-AWGHDCB-WFXV6AE";};
      };

      folders = {
        "dox" = {
          id = "4lkyi-u5rlc";
          path = "~/dox";
          devices = ["anser"];
          ignorePerms = false;
        };
        "music" = {
          id = "hygaw-rg6ui";
          path = "~/music";
          devices = ["anser"];
          ignorePerms = false;
        };
        "pix" = {
          id = "zdjf-o6neh";
          path = "~/pix";
          devices = ["anser"];
          ignorePerms = false;
        };
        "vids" = {
          id = "kqsee-nrs9r";
          path = "~/vids";
          devices = ["anser"];
          ignorePerms = false;
        };
      };

      options.urAccepted = -1; # Disable telemetry.
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # TODO: Impermanence (https://notthebe.ee/blog/nixos-ephemeral-zfs-root/)
  # TODO: nix-ld)

  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["corefonts" "vista-fonts"];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    binfmt = {
      emulatedSystems = ["aarch64-linux" "riscv64-linux"];
    };
  };

  # TODO: network-manager wireless
  # networking.wireless.enable = true;

  networking.networkmanager.enable = true;

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

  programs.hyprland.enable = true;
  hardware = {
    graphics.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["networkmanager" "wheel"];
    hashedPasswordFile = config.age.secrets."chonk.hashedPassword".path;
  };

  home-manager = {
    users.chonk = import ./home.nix;
  };

  programs.firefox.enable = true;

  chonkos = {
    user = "chonk";
    tailscale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}

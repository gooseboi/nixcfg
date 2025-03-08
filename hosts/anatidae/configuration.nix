{
  pkgs,
  lib,
  inputs,
  ...
}: {
  # TODO: Impermanence (https://notthebe.ee/blog/nixos-ephemeral-zfs-root/)
  # TODO: binfmt registrations (https://mynixos.com/nixpkgs/option/boot.binfmt.emulatedSystems)

  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["corefonts" "vista-fonts"];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.luks.devices."luks-d2e00eab-b629-46f1-8127-283fe4bba9eb".device = "/dev/disk/by-uuid/d2e00eab-b629-46f1-8127-283fe4bba9eb";
  };

  # TODO: network-manager wireless
  # networking.wireless.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Montevideo";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
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

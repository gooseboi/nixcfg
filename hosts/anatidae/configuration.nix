{config, ...}: {
  # TODO: Impermanence (https://notthebe.ee/blog/nixos-ephemeral-zfs-root/)

  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ./syncthing.nix
    ./brave
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

  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["wheel" "video" "audio" "dialout"];
    hashedPasswordFile = config.age.secrets.chonk-hashedPassword.path;
  };

  home-manager.users.chonk = import ./home.nix;

  chonkos = {
    user = "chonk";
    agenix.enable = true;
    desktop.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
    zsh.enableVimMode = true;
    network-manager.enable = true;
    tlp.enable = true;
    docker.enable = true;
    virt-manager.enable = true;
    hyprland.enable = true;
    i18n.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
